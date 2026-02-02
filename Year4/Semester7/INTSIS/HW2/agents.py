import math
import random
import time


class Agent:
    ident = 0

    def __init__(self):
        self.id = Agent.ident
        Agent.ident += 1

    def get_chosen_action(self, state, max_depth):
        pass


class RandomAgent(Agent):
    def get_chosen_action(self, state, max_depth):
        time.sleep(0.5)
        actions = state.get_legal_actions()
        return actions[random.randint(0, len(actions) - 1)]


class GreedyAgent(Agent):
    def get_chosen_action(self, state, max_depth):
        time.sleep(0.5)
        actions = state.get_legal_actions()
        best_score, best_action = None, None
        for action in actions:
            new_state = state.generate_successor_state(action)
            score = new_state.get_score(state.get_on_move_chr())
            if (best_score is None and best_action is None) or score > best_score:
                best_action = action
                best_score = score
        return best_action


class MaxNAgent(Agent):

    # if is_terminal_node(node):
    #     return node_evaluation_list(node)
    # score_list = [-math.inf for i in range(get_player_count())]
    # i = player.get_index()
    # for succ in node.successors():
    #     child_score_list = max_n(node, get_next(player))
    #     score_list = score_list if score_list[i] >= child_score_list[i] else child_score_list)
    # return score_list

    @staticmethod
    def max_n(state, max_depth, depth):

        if depth == max_depth or state.is_goal_state():
            return state.get_scores(), None

        player = state.get_on_move_chr()

        best_score = {ch: -math.inf for ch in state.get_scores().keys()}
        best_action = None

        for action in state.get_legal_actions():

            new_state = state.generate_successor_state(action)
            child_scores, _ = MaxNAgent.max_n(new_state, max_depth, depth+1)

            if child_scores[player] > best_score[player]:
                best_score = child_scores
                best_action = action

        return best_score, best_action

    def get_chosen_action(self, state, max_depth):

        return MaxNAgent.max_n(state, max_depth, 0)[1]


class MinimaxAgent(Agent):
    # if is_terminal_node(node):
    #     return node_evaluation(node)
    # if player == Player.MAX:
    #     score = -math.inf
    #     for succ in node.successors():
    #         score = max(score, minimax(succ, Player.MIN))
    #     return score
    # else:
    #     score = +math.inf
    #     for succ in node.successors():
    #         score = min(score, minimax(succ, Player.MAX))
    #     return score

    @staticmethod
    def minimax(state, max_depth, depth, max_player, min_player):

        if depth == max_depth or state.is_goal_state():
            scores = state.get_scores()
            # on_move = state.get_on_move_chr()
            # not_move = min_player if on_move == max_player else max_player
            return scores[max_player] - scores[min_player], None

        player = state.get_on_move_chr()

        if player == max_player:
            best_score = -math.inf
        else:
            best_score = math.inf

        best_action = None

        for action in state.get_legal_actions():

            new_state = state.generate_successor_state(action)
            child_score, _ = MinimaxAgent.minimax(new_state, max_depth, depth+1, max_player, min_player)

            if (player == max_player and child_score > best_score) or \
                    (player != max_player and child_score < best_score):
                best_score = child_score
                best_action = action

        return best_score, best_action

    def get_chosen_action(self, state, max_depth):
        max_player, min_player = '', ''
        for ch in state.get_scores().keys():
            if ch == state.get_on_move_chr():
                max_player = ch
            else:
                min_player = ch
        return MinimaxAgent.minimax(state, max_depth, 0, max_player, min_player)[1]

class MinimaxABAgent(Agent):
    # if is_terminal_node(node):
    #     return node_evaluation(node)
    # if player == Player.MAX:
    #     score = -math.inf
    #     for succ in node.successors():
    #         score = max(score, minimax_alpha_beta(succ, Player.MIN, alpha, beta))
    #         alpha = max(alpha, score)
    #         if alpha >= beta: break  # alpha-cut
    #     return score
    # else:
    #     score = +math.inf
    #     for succ in node.successors():
    #         score = min(score, minimax_alpha_beta(succ, Player.MAX, alpha, beta))
    #         beta = min(beta, score)
    #         if alpha >= beta: break  # beta-cut
    #     return score

    @staticmethod
    def minimax_ab(state, max_depth, depth, max_player, min_player, alpha, beta):

        if depth == max_depth or state.is_goal_state():
            scores = state.get_scores()
            # on_move = state.get_on_move_chr()
            # not_move = min_player if on_move == max_player else max_player
            return scores[max_player] - scores[min_player], None

        player = state.get_on_move_chr()

        if player == max_player:
            best_score = -math.inf
        else:
            best_score = math.inf

        best_action = None

        for action in state.get_legal_actions():

            new_state = state.generate_successor_state(action)
            child_score, _ = MinimaxABAgent.minimax_ab(new_state, max_depth, depth+1, max_player, min_player, alpha, beta)

            if (player == max_player and child_score > best_score) or \
                    (player != max_player and child_score < best_score):
                best_score = child_score
                best_action = action

            if player == max_player:
                alpha = max(alpha, best_score)
            else:
                beta = min(beta, best_score)

            if alpha >= beta:
                break

        return best_score, best_action


    def get_chosen_action(self, state, max_depth):
        max_player, min_player = '', ''
        for ch in state.get_scores().keys():
            if ch == state.get_on_move_chr():
                max_player = ch
            else:
                min_player = ch
        return MinimaxABAgent.minimax_ab(state, max_depth, 0, max_player, min_player, -math.inf, math.inf)[1]

