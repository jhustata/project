<!-- Include MathJax script in the head of your HTML document -->
<head>
  <script src="https://polyfill.io/v3/polyfill.min.js?features=es6"></script>
  <script id="MathJax-script" async src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js"></script>
</head>

<!-- Wrap your LaTeX equations in MathJax delimiters -->
<!-- Single-line equation -->
$$ Y = \beta_0 + \beta_1X_1 + \beta_2X_2 + \cdots + \beta_NX_N + \epsilon_i $$


The coefficient matrix for the model specified above is:

<!-- Multi-line equation -->
$$
\begin{bmatrix}
\beta_0 \\
\beta_1 \\
\beta_2 \\
\vdots \\
\beta_N
\end{bmatrix}
$$

And the variance-covariance matrix for the errors $\epsilon_i$ in the model is typically denoted as $\sigma^2\times I$, where $\sigma^2$ is the variance of the errors and $I$ is the identity matrix. The variance-covariance matrix for the errors is:

<!-- Another multi-line equation -->
$$
\begin{bmatrix}
\sigma^2 & 0 & 0 & \cdots & 0 \\
0 & \sigma^2 & 0 & \cdots & 0 \\
0 & 0 & \sigma^2 & \cdots & 0 \\
\vdots & \vdots & \vdots & \ddots & \vdots \\
0 & 0 & 0 & \cdots & \sigma^2
\end{bmatrix}
$$
