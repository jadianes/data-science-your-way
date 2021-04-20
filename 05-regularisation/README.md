# Regularised linear models for regression

## (Gaussian) Linear models for regression

The goal of regression is to predict the value of one or more continuous *target* variables $y$ given the value of a $p$-dimensional vector $\vec{x}$ of input variables [1]. 

$$
x_1, x_2, \dots, x_p \rightarrow y
$$

The simplest linear regression models share the property of being linear functions of the input parameters. If we call that function $f$, a model prediction $\hat{y}$ for a given value of the input vector $\vec{x}$ is given by 

$$
\hat{y} = f(x_1, x_2, \dots, x_p)
$$

The process of learning the function $f$ is what machine learning or statistical learning is about. We use a dataset D, made of $N$ labeled samples $(x_1, x_2, \dots, x_p, y)$, to estimate the function $f$. We will get a bit deeper into this subject in the following sections, in the context of cost functions and regularisation. But in principle, for each data point, we have that 


$$
y_i = f(\vec{x}_i) + \epsilon
$$

This is equivalent to say that for each sample, the target variable is given by a deterministic function (i.e. $f$) plus noise. Probably the most popular the most popular family of models comes from the assumption that the error $\epsilon$ is normally distributed (i.e. Gaussian), which is not a bad assumption in most real world scenarios thanks to the central limit theorem. That is equivalent to say that the input vector and output variable together make a multi-variate normal distribution $(x_1, x_2, \dots, x_p, y)$. If we take a probabilistic approach, we can describe each data point as:

$$
p(y_i | \vec{x}_i) \sim N(\mu_i, \sigma^2)
$$

that is, the target variable $y$ is normally distributed conditional to the values of $\vec{x}$ where 

$$
\mu_i = \beta_1 \Phi_1(x_1) + \dots + \beta_r \Phi_r(x_i)
$$

that is, we define the function $f$ (and the center of the distribution) in terms of a series of $r$ weights or coefficients $\vec{\beta}$ and selection functions $\vec{\Phi}$ that combine the values of the inputs to get the output. Finally, if we define for the whole dataset 

$$
Y = \begin{pmatrix}
y_1 \\ 
y_2 \\ 
\dots \\ 
y_N
\end{pmatrix}

\vec{\beta} = \begin{pmatrix}
\beta_1 \\ 
\beta_2 \\ 
\dots \\ 
\beta_r
\end{pmatrix}

X = \begin{pmatrix}
\Phi_1(x_1) && \Phi_2(x_1) && \dots && \Phi_r(x_1) \\ 
\Phi_1(x_2) && \Phi_2(x_2) && \dots && \Phi_r(x_2) \\ 
\Phi_1(x_3) && \Phi_2(x_3) && \dots && \Phi_r(x_3) \\ 
\dots && \dots && \dots && \dots \\
\Phi_1(x_N) && \Phi_2(x_N) && \dots && \Phi_r(x_N) \\ 
\end{pmatrix}
$$ and 

we have that 

$$
Y = X \vec{\beta} + \epsilon
$$

or equivalently

$$
p(Y) \sim N(X \vec{\beta}, \sigma^2 I)
$$

The problem is then to estimate the coefficients vector $\vec{\beta}$. Two ways of estimate these values are *least squares estimation* and *maximum likelihood estimation*. Although the are equivalent for linear gaussian models, they do not have to be. We will focus on the first approach for the time being.

## Least Squares Estimation

The LSE method uses a cost function $S$, the residual sum of squares, which we aim to minimise:

$$
S(\vec{\beta}) = \sum_{i=1}^{N} (Y_i - \sum_{k=1}^{r} \beta_k \Phi_k(x_i))^2 = (Y - X\vec{\beta})^T(Y-X \vec{\beta})
$$

That is, we sum, over all $N$ samples in out dataset, the squared difference between the actual value $Y_i$ and the prediction.

## A regularised cost function

## Regularised linear models in Python

## References

1. Bishop. *Pattern recognition and machine learning*. 2006


