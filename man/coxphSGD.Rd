% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/coxphSGD.R
\name{coxphSGD}
\alias{coxphSGD}
\title{Stochastic Gradient Descent log-likelihood Estimation in
Cox Proportional Hazards Model}
\usage{
coxphSGD(formula, data, learn.rates = function(x) {     1/x },
  beta.zero = 0, epsilon = 1e-05, max.iter = 500, verbose = FALSE)
}
\arguments{
\item{formula}{a formula object, with the response on the left of a ~ operator,
and the terms on the right. The response must be a survival object as returned by
the Surv function.}

\item{data}{a list of batch data.frames in which to interpret the variables named in the \code{formula}.
See Details.}

\item{learn.rates}{a function specifing how to define learning rates in
steps of the algorithm. By default the \code{f(t)=1/t} is used, where \code{t} is
the number of algorithm's step.}

\item{beta.zero}{a numeric vector (if of length 1 then will be replicated) of length
equal to the number of variables after using \code{formula} in the \code{model.matrix}
function}

\item{epsilon}{a numeric value with the stop condition of the estimation algorithm.}

\item{max.iter}{numeric specifing maximal number of iterations.}

\item{verbose}{whether to cat the number of the iteration}
}
\description{
\code{coxphSGD} estimates coefficients using stochastic
gradient descent algorithm in Cox proportional hazards model.
}
\details{
A \code{data} argument should be a list of data.frames, where in every batch data.frame
there is the same structure and naming convention for explanatory and survival (times, censoring)
variables. See Examples.
}
\note{
If one of the conditions is fullfiled (j denotes the step number)
\itemize{
 \item \eqn{||\beta_{j+1}-\beta_{j}|| <}\code{epsilon} parameter for any \eqn{j}
 \item \eqn{j>max.iter}
}
the estimation process is stopped.
}
\examples{
library(survival)
set.seed(456)
x <- matrix(sample(0:1, size = 20000, replace = TRUE), ncol = 2)
head(x)
dCox <- dataCox(10^4, lambda = 3, rho = 2, x,
                beta = c(2,2), cens.rate = 5)
batch_id <- sample(1:90, size = 10^4, replace = TRUE)
dCox_split <- split(dCox, batch_id)
results <-
  coxphSGD(formula     = Surv(time, status) ~ x.1+x.2,
           data        = dCox_split,
           epsilon     = 1e-5,
           learn.rates = function(x){1/(100*sqrt(x))},
           beta.zero   = c(0,0),
           max.iter    = 10*90)
coeff_by_iteration <-
  as.data.frame(
    do.call(
      rbind,
      results$coefficients
    )
  )
head(coeff_by_iteration)
}
\author{
Marcin Kosinski, \email{m.p.kosinski@gmail.com}
}
