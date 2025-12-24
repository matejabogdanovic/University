from __future__ import annotations

import heapq
import random
from collections import defaultdict
from dataclasses import dataclass
from typing import Callable

from core.grid import Grid
from core.path import Path
from core.tiles import Tile


@dataclass(slots=True)
class Agent:
    name: str

    def find_path(self, grid: Grid, start: tuple[int, int], goal: tuple[int, int]) -> Path:
        raise NotImplementedError


class ExampleAgent(Agent):

    def __init__(self):
        super().__init__("Example")

    def find_path(self, grid: Grid, start: tuple[int, int], goal: tuple[int, int]) -> Path:
        nodes = [start]
        while nodes[-1] != goal:
            r, c = nodes[-1]
            neighbors = grid.neighbors4(r, c)

            min_dist = min(grid.manhattan(t.pos, goal) for t in neighbors)
            best_tiles = [
                tile for tile in neighbors
                if grid.manhattan(tile.pos, goal) == min_dist
            ]
            best_tile = best_tiles[random.randint(0, len(best_tiles) - 1)]

            nodes.append(best_tile.pos)

        return Path(nodes)


class DFSAgent(Agent):

    nodes: list[tuple[int, int]] = []
    visited = []

    def __init__(self):
        super().__init__("DFS")

    def dfs(self,  grid: Grid, curr: tuple[int, int], goal: tuple[int, int]):
        if curr == goal:
            self.nodes.append(goal)
            return True

        row, col = curr

        def sorting_func(tile: Tile):
            x, y = tile.row - row, tile.col - col
            if (x, y) == (0, 1):  # istok
                compass = 0
            elif (x, y) == (1, 0):  # jug
                compass = 1
            elif (x, y) == (0, -1):  # zapad
                compass = 2
            else:
                compass = 3  # sever - (-1, 0)
            return tile.cost, compass

        self.visited[row][col] = True
        neighbors = sorted(grid.neighbors4(row, col), key=sorting_func)
        for n in neighbors:
            if not self.visited[n.row][n.col] and self.dfs(grid, n.pos, goal):
                self.nodes.append(curr)
                return True

        return False

    def find_path(self, grid: Grid, start: tuple[int, int], goal: tuple[int, int]) -> Path:
        self.visited = [[False for _ in range(grid.cols)] for _ in range(grid.rows)]
        self.dfs(grid, start, goal)
        self.nodes.reverse()
        return Path(self.nodes)


class BranchAndBoundAgent(Agent):

    class PartialPath:
        nodes: list[tuple[int, int]]
        cost: int
        # visited: set

        def __init__(self, _nodes: list[tuple[int, int]], _cost: int):
            self.nodes = _nodes
            self.cost = _cost
            # self.visited = set(_nodes)

        def __lt__(self, other):
            return (self.cost, len(self.nodes)) < (other.cost, len(other.nodes))

        # def contains(self, _node: tuple[int, int]) -> bool:
        #     return _node in self.visited

    def __init__(self):
        super().__init__("BranchAndBound")

    def branch_and_bound(self, grid: Grid, start: tuple[int, int], goal: tuple[int, int]):
        # dp = defaultdict(lambda: -1) # dinamicko programiranje
        dp = [[-1 for _ in range(grid.cols)] for _ in range(grid.rows)]
        partial_paths = []

        heapq.heappush(partial_paths, self.PartialPath([start], 0))
        dp[start[0]][start[1]] = 0
        # dp[start] = 0
        # iter = 0
        while len(partial_paths) > 0:
            curr = heapq.heappop(partial_paths)
            last_node = curr.nodes[-1]
            # iter += 1
            if last_node == goal:
                # print(f"Iter number: {iter}")
                return curr.nodes
            neighbors = grid.neighbors4(last_node[0], last_node[1])
            for n in neighbors:
                new_cost = curr.cost + n.cost
                # ako je cena nove parcijalne putanje veca od onog sto imamo u dp
                # onda mozemo odbaciti tu putanju jer sigurno nije bolja
                # ovakav nacin zaustavlja i cikluse
                if dp[n.row][n.col] < 0 or dp[n.row][n.col] >= new_cost:
                    dp[n.row][n.col] = new_cost
                    heapq.heappush(partial_paths, self.PartialPath(curr.nodes + [n.pos], new_cost))
        return []

    def find_path(self, grid: Grid, start: tuple[int, int], goal: tuple[int, int]) -> Path:
        return Path(self.branch_and_bound(grid, start, goal))


class AStar(Agent):
    # samo se razlikuje lt i polje za heruistiku poslednjeg cvora
    class PartialPath:
        nodes: list[tuple[int, int]]
        cost: int
        # visited: set
        heuristic: int

        def __init__(self, _nodes: list[tuple[int, int]], _cost: int, _heuristic: int):
            self.nodes = _nodes
            self.cost = _cost
            # self.visited = set(_nodes)
            self.heuristic = _heuristic

        def __lt__(self, other):
            return (self.cost+self.heuristic, len(self.nodes)) < (other.cost+other.heuristic, len(other.nodes))

        # def contains(self, _node: tuple[int, int]) -> bool:
        #     return _node in self.visited

    def __init__(self):
        super().__init__("AStar")

    # kod je isti kao za branch i bound samo sto racunamo herusitiku za nov cvor
    # moze i unapred da se odrede herusitike da se ne racuna
    def a_star(self, grid: Grid, start: tuple[int, int], goal: tuple[int, int]):
        dp = [[-1 for _ in range(grid.cols)] for _ in range(grid.rows)]
        partial_paths = []
        heapq.heappush(partial_paths, self.PartialPath([start], 0, 0))
        dp[start[0]][start[1]] = 0
        # iter = 0
        while len(partial_paths) > 0:
            curr = heapq.heappop(partial_paths)
            last_node = curr.nodes[-1]
            # iter += 1
            # print(f"Iter number: {iter} - {curr.nodes} - (C){curr.cost} + (H){curr.heuristic} = {curr.cost+curr.heuristic}")
            if last_node == goal:
                # print(f"Iter number: {iter}")
                return curr.nodes
            neighbors = grid.neighbors4(last_node[0], last_node[1])
            for n in neighbors:
                new_cost = curr.cost + n.cost
                # mahattan distanca je uvek ista za jedan cvor
                # zato ako je cena nove parcijalne putanje veca od onog sto imamo u dp
                # onda mozemo odbaciti tu putanju jer sigurno nije bolja
                # ovakav nacin zaustavlja i cikluse

                if dp[n.row][n.col] < 0 or dp[n.row][n.col] >= new_cost:
                    # print(f"Adding new node + {n.pos} - (C){new_cost} + (H){grid.manhattan(n.pos, goal)} = {new_cost+grid.manhattan(n.pos, goal)}")
                    dp[n.row][n.col] = new_cost
                    heapq.heappush(partial_paths, self.PartialPath(curr.nodes + [n.pos], new_cost,
                                                                   grid.manhattan(n.pos, goal)))
        return []

    def find_path(self, grid: Grid, start: tuple[int, int], goal: tuple[int, int]) -> Path:
        return Path(self.a_star(grid, start, goal))


AGENTS: dict[str, Callable[[], Agent]] = {
    "Example": ExampleAgent,
    "DFS": DFSAgent,
    "BranchAndBound": BranchAndBoundAgent,
    "AStar": AStar
}


def create_agent(name: str) -> Agent:
    if name not in AGENTS:
        raise ValueError(f"Unknown agent '{name}'. Available: {', '.join(AGENTS.keys())}")
    return AGENTS[name]()
