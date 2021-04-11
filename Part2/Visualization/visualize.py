import qsharp
from QuantumCounting import MeasureTarget
import matplotlib.pyplot as plt
import numpy as np

def main():

    # Instantiate variables
    frequency =  {}
    N_Experiments = 1000
    results = []

    # Run N_Experiments times the Q# operation.
    for i in range(N_Experiments):
        print(f'Experiment: {i} of {N_Experiments}')
        results.append(MeasureTarget.simulate())

    # Store the results in a dictionary
    for i in results:
        if i in frequency:
            frequency[i]=frequency[i]+1
        else:
            frequency[i]=1

    # Sort and print the results
    frequency = dict(reversed(sorted(frequency.items(), key=lambda item: item[1])))
    print('Output,  Frequency' )
    for k, v in frequency.items():
        print(f'{k:<8} {v}')

    # Plot an histogram with the results
    plt.bar(frequency.keys(), frequency.values())
    plt.xlabel("Output")
    plt.ylabel("Frequency of the outputs")
    plt.title("Outputs for Grover's counting for 1000 iterations")
    plt.xticks(np.arange(0, 16, 1.0))
    plt.show()

if __name__ == "__main__":
    main()