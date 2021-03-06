
![image](graphic.PNG)

# Quantum counting

As you've probably learned from the other Microsoft Katas, Grover's algorithm is a way of accelerating unstructured search on quantum computers.  Importantly, one must know both the total size of the search space (<img src="https://render.githubusercontent.com/render/math?math=N"> ), and the total number of solutions to the search problem (<img src="https://render.githubusercontent.com/render/math?math=M"> ), to know the angle (<img src="https://render.githubusercontent.com/render/math?math=\theta"> ) that each Grover step rotates the state by:

<img src="https://render.githubusercontent.com/render/math?math=\sin^2{\theta/2} = M/2N">

This provides a stopping condition, becausing applying too many Grover steps will rotate the state past the point when the maximal success probability is achieved (i.e. when meausuring the output register will produce a bitstring that is included in the known solution set).  This discussion begs the question: what if you don't know the total number of solutions beforehand?  


One could always run Grover search for a range of different <img src="https://render.githubusercontent.com/render/math?math=M">s, mesuring the output over each iteration and checking for those which are valid solutions, but we can do better.  The quantum couting algorithm (NC pg. 263) presents a solution, where one can use the quantum phase estimation algorithm (QPE) to estimate the eigenvalues of some unitary <img src="https://render.githubusercontent.com/render/math?math=U"> , where <img src="https://render.githubusercontent.com/render/math?math=U">  is the Grover interation, which is 

<a href="https://www.codecogs.com/eqnedit.php?latex=G=&space;\begin{bmatrix}&space;cos(\theta)&-sin(\theta)\\&space;sin(\theta)&cos(\theta)&space;\end{bmatrix}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?G=&space;\begin{bmatrix}&space;cos(\theta)&-sin(\theta)\\&space;sin(\theta)&cos(\theta)&space;\end{bmatrix}" title="G= \begin{bmatrix} cos(\theta)&-sin(\theta)\\ sin(\theta)&cos(\theta) \end{bmatrix}" /></a>

in the 2-d basis spanned by <img src="https://render.githubusercontent.com/render/math?math=|\alpha\rangle"> and <img src="https://render.githubusercontent.com/render/math?math=|\beta\rangle">, which are superpositions over all solutions and non-solutions to the search problem, respectively.  <img src="https://render.githubusercontent.com/render/math?math=G">  has eigenvalues <img src="https://render.githubusercontent.com/render/math?math=e^{i\theta}"> and <img src="https://render.githubusercontent.com/render/math?math=e^{i(2\pi-\theta)}">, which we then seek to estimate via quantum phase estimation.  Knowing <img src="https://render.githubusercontent.com/render/math?math=\theta"> and <img src="https://render.githubusercontent.com/render/math?math=N"> , we can compute <img src="https://render.githubusercontent.com/render/math?math=M">  and thus know how many solutions exist to our search problem.  The circuit is 

![image](circuit.PNG)

Importantly, in QPE we need to prepare an eigenstate of <img src="https://render.githubusercontent.com/render/math?math=U">  on the target register, in order to extact the eigenvalue of <img src="https://render.githubusercontent.com/render/math?math=|u\rangle"> into the phase of the control qubits.  Since don't know <img src="https://render.githubusercontent.com/render/math?math=\theta"> yet, we cannot prepare an eigenstate, so we just prepare a uniform superposition, which is a superposition of <img src="https://render.githubusercontent.com/render/math?math=|a\rangle"> and <img src="https://render.githubusercontent.com/render/math?math=|b\rangle">, by which we denote the two eigenvectors of <img src="https://render.githubusercontent.com/render/math?math=U"> (these lie in the same plane as <img src="https://render.githubusercontent.com/render/math?math=|\alpha\rangle"> and <img src="https://render.githubusercontent.com/render/math?math=|\beta\rangle">, but define a rotated basis).  Thus, we extract either <img src="https://render.githubusercontent.com/render/math?math=\theta"> or <img src="https://render.githubusercontent.com/render/math?math=2\pi - \theta"> with some probability, which are both fine since we plug them into <img src="https://render.githubusercontent.com/render/math?math=\sin^2 \theta/2"> in the end.

In the displayed circuit diagram, <img src="https://render.githubusercontent.com/render/math?math=t"> refers to the number of qubits needed in QPE, and ultimately determines the resolution with which we can learn <img src="https://render.githubusercontent.com/render/math?math=\theta">, and also the probability with which the circuit succeeds at all.  The <img src="https://render.githubusercontent.com/render/math?math=n"> register refers to the workspace of the Grover unitary, which just needs however many qubits are involved in the search algorithm.


Running the Python code `visualize.py` in the Visualization folder one obtains the following plot:
![image](https://user-images.githubusercontent.com/30697242/114305759-d231ec80-9ad9-11eb-82fb-d60fd6c5c362.png)


The correct result is 2, given the implemented oracle which flags either all 0s or all 1s.  The output axis in the plot displays the estimated probabilities of each outcome, if the bin label is converted to a binary string.  We observe a clear bunching around the correct bin, with artefacts at 0 and 16, presumably due to finite time effects ;)

### References

- Nielsen & Chuang Chapter 6

- https://en.wikipedia.org/wiki/Grover%27s_algorithm

- https://en.wikipedia.org/wiki/Quantum_phase_estimation_algorithm
