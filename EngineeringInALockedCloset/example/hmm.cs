


// Specify a initial normal distribution for the samples.
var initialDensity = MultivariateNormalDistribution(3); // 3 dimensions

// Create a continuous hidden Markov Model with two states organized in a forward
//  topology and an underlying multivariate Normal distribution as probability density.
var model = new HiddenMarkovModel<MultivariateNormalDistribution>(new Ergodic(2), density);

// Configure the learning algorithms to train the sequence classifier until the
// difference in the average log-likelihood changes only by as little as 0.0001
var teacher = new BaumWelchLearning<MultivariateNormalDistribution>(model)
{
    Tolerance = 0.0001,
    Iterations = 0,
};

// Fit the model
double likelihood = teacher.Run(sequences);