# Payoff Matrix

Payoff matrix creation and real-time decision analysis with multiple decision criteria support. Including Maximax, Maximin, Laplace, Savage, Hurwicz, Action Expected Value (VEA), Perfect Information Expected Value (VEIP) and optimal alternative.
<br/><br/>

- Maximax: a criterion for risk-takers, it selects the alternative with the maximum possible payoff, focusing on the most optimistic scenario.

- Maximin: a conservative criterion that chooses the alternative with the best worst-case outcome, prioritizing risk minimization.

- Laplace: assumes all outcomes are equally likely and selects the alternative with the highest average payoff, balancing optimism and pessimism.

- Savage: also known as the minimax, it chooses the alternative that minimizes the maximum regret, focusing on avoiding missed opportunities.

- Hurwicz: a compromise between optimism and pessimism, this criterion weights the best and worst payoffs with a coefficient to find a balance in decision-making.

- Action Expected Value (VEA): calculates the expected payoff for each alternative, taking into account probabilities, to select the best choice.

- Perfect Information Expected Value (VEIP): measures the value of knowing the outcome with certainty before making a decision, comparing the expected benefit of perfect information with the best action under uncertainty.

- Optimal Alternative: The decision that provides the best overall outcome based on all decision criterion. 
<br/><br/><br/>

![Demo](./demo/demo.gif)

## Try it out

See the project in action [here](https://payoffmatrix.surge.sh/).

## Installation

1. Clone the repository.

2. Make sure you have Flutter 3.24.2 installed.

3. Navigate to the project directory and install dependencies:

```bash
cd payoff_matrix
flutter pub get
```

3. Run the app:

```bash
flutter run
```

## License

This project is licensed under the BSD (3-Clause) License - see the LICENSE file for details.
