# Quantum counting

As you've probably learned from the other Microsoft Katas, Grover's algorithm is a way of accelerating unstructured search on quantum computers.  Importantly, one must know both the total size of the search space ($N$), and the total number of solutions to the search problem ($M$), to know the angle ($\theta$) that each Grover step rotates the state by:

\begin{align}
    \sin^2{\theta/2} = M/2N
\end{align}

This provides a stopping condition, becausing applying too many Grover steps will rotate the state past the point when the maximal success probability is achieved (i.e. when meausuring the output register will produce a bitstring that is included in the known solution set).  This discussion begs the question: what if you don't know the total number of solutions beforehand?  

One could always run Grover search for a range of different $M$s, mesuring the output over each iteration and checking for those which are valid solutions, but we can do better.  The quantum couting algorithm (NC pg. 263) presents a solution, where one can use the quantum phase estimation algorithm (QPE) to estimate the eigenvalues of some unitary $U$, where $U$ is the Grover interation, which is 

\begin{align}
    G = \begin{bmatrix}
    cos(\theta) & -sin(\theta)\\
    sin(\theta) & cos(\theta)
    \end{bmatrix}
\end{align}

in the 2-d basis spanned by $|\alpha\rangle$ and $|\beta\rangle$, which are superpositions over all solutions and non-solutions to the search problem, respectively.  $G$ has eigenvalues $e^{i\theta}$ and $e^{i(2\pi-\theta)}$, which we then seek to estimate via quantum phase estimation.  Knowing $\theta$ and $N$, we can compute $M$ and thus know how many solutions exist to our search problem.  The circuit is 

![image](circuit.PNG)

Importantly, in QPE we need to prepare an eigenstate of $U$ on the target register, in order to extact the eigenvalue of $|u\rangle$ into the phase of the control qubits.  Since don't know $\theta$ yet, we cannot prepare an eigenstate, so we just prepare a uniform superposition, which is a superposition of $|a\rangle$ and $|b\rangle$, by which we denote the two eigenvectors of $U$ (these lie in the same plane as $|\alpha\rangle$ and $|\beta\rangle$, but define a rotated basis).  Thus, we extract either $\theta$ or $(2\pi - \theta)$ with some probability, which are both fine since we plug them into $\sin^2$ in the end.