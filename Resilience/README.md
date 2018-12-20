# Overview
This file contains the basic setting, the function for the computation of the resilience mu and a launcher which runs the simulations for every values of delta and xi and plot the results. As first step, set as G the current network, then set the values for δ and ξ. Within the function mu there are lines of codes for the three gamma and three theta settings.

Please uncomment the lines as your choice. Please note that the code is not optimized and hopefully without major bug.
Any comments or corrections are really welcome.

## Publication
The publication titled: Measuring network resilience through connection patterns is available at https://arxiv.org/abs/1808.07731

Authors:
- Roy Cerqueti
- Giovanna Ferraro
- Antonio Iovanella

## Variables
- ξ is the size of the shock, goes from 0 to +∞
- δ is the discount factor, is limited in (0, 1)
- Γ is the propagation vector
- Θ is the coefficients vector for the convex combination

In order to run the code, set the correct choice for Γ and Θ whitin the code in file mu.r, than consider file launcher.r.

We thanks also Kevin Mader to let available the code on [his page on Kaggle](https://www.kaggle.com/kmader/network-resilience/notebook).
