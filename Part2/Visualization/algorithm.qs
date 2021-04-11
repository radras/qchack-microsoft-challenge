namespace QuantumCounting{

open Microsoft.Quantum.Measurement;
open Microsoft.Quantum.Math;
open Microsoft.Quantum.Arrays;
open Microsoft.Quantum.Preparation;
open Microsoft.Quantum.Characterization;
open Microsoft.Quantum.Oracles;
open Microsoft.Quantum.Arithmetic;
open Microsoft.Quantum.Convert;
open Microsoft.Quantum.Canon;
open Microsoft.Quantum.Intrinsic;

operation Oracle(groverQubits : Qubit[]) : Unit is Adj+Ctl {
    Controlled X(Most(groverQubits), Tail(groverQubits));
    within {
        ApplyToEachA(X, Most(groverQubits));
    }
    apply {
        Controlled X(Most(groverQubits), Tail(groverQubits));
    }
}

// Grover diffusion operator
operation GroverDiffusion(groverQubits : Qubit[]) : Unit is Adj+Ctl {
    within {
        ApplyToEachA(H, Most(groverQubits));
        ApplyToEachA(X, Most(groverQubits));
    } apply {
        Controlled Z(Most(Most(groverQubits)), Tail(Most(groverQubits)));
    }
}

// Circuit performing a single Grover iteration
operation GroverIteration(groverQubits : Qubit[]): Unit is Adj+Ctl {
    Oracle(groverQubits);
    GroverDiffusion(groverQubits);
}


operation GroverPow(power: Int, groverQubits : Qubit[]): Unit is Adj+Ctl {
    for i in 1 .. power {
        GroverIteration(groverQubits);
    }
}

// Circuit implementing the Quantum phase estimation algorithm
operation QuantumCounting(groverQubits : Qubit[], targetQubits : Qubit[]) : Unit is Adj+Ctl {
    let oracle = DiscreteOracle(GroverPow);
    QuantumPhaseEstimation(oracle, groverQubits, BigEndian(targetQubits));
}

@EntryPoint()
operation MeasureTarget() : Int {
    use groverQubits = Qubit[5];
    use targetQubits = Qubit[5];
    
    QuantumCounting(groverQubits, targetQubits);
    
    let a = BoolArrayAsInt(Reversed(ResultArrayAsBoolArray(MultiM(targetQubits))));
    ResetAll(groverQubits);
    ResetAll(targetQubits);
    
    let theta = 2.0 * PI() * IntAsDouble(a) / IntAsDouble(2 ^ Length(targetQubits));
    let numSolutions= PowD(Cos(theta / 2.0), 2.0) * IntAsDouble(2 ^ (Length(groverQubits) - 1));
    Message($"a: {a}");
    return Round(numSolutions);
}


}