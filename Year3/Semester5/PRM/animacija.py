from matplotlib.animation import FuncAnimation

import sympy as sym
import numpy as np
import matplotlib.pyplot as plt
sym.init_printing() # lep ispis

x = sym.Symbol("x")
f = sym.sqrt(1-x**2)
f
f_lambdified = sym.lambdify(x, f, 'numpy')
x_vals = np.linspace(-1, 1, 100) # 100 odbiraka
x_vals
fig, ax = plt.subplots()

ax.plot(x_vals, f_lambdified(x_vals), color="red")
ax.set_aspect('equal')
ax.axhline(0, color='black', linewidth=0.8, linestyle='-') # x osa je puna linija 
ax.axvline(0, color='black', linewidth=0.8, linestyle='-') # y osa je isprekidana linija
ax.set_xlim(-1.1, 1.1)
ax.set_ylim(0, 1.1)
ax.grid(alpha=0.5)

animated_plot, = ax.plot([],[])

y_vals=f_lambdified(x_vals)
povrsina = 0
def animacija(i):
    global povrsina
    x = x_vals[i+1] - x_vals[i]
    y = f_lambdified(x_vals[i+1])
     
    plt.fill_between([x_vals[i], x_vals[i+1]], 0, y, color='blue', alpha=0.5)
    
    p = x*y
    povrsina+=p
    animated_plot.set_data(x_vals[:i], y_vals[:i])
    return 
  
ani = FuncAnimation(fig, func = animacija, frames=len(x_vals)-1, interval=25, repeat=False)
ani.save("animacija.gif", writer = 'pillow')
#plt.show()

#print('Aproksimirana površina: ', povrsina, '\nPrava površina: ', (sym.pi/2).evalf()) 