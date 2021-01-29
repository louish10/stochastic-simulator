using Plots

function main()
    n_simulations = 50000
    steady_states = zeros(n_simulations)
    for i in 1:n_simulations
        x, t = simulate_network(5, 0.3)
        steady_states[i] = last(x)
        println(i)
    end
    x_true = zeros(40)
    for i in 1:40
        x_true[i] = (1/factorial(big(i))*(5/0.3)^i * exp(-5/0.3))
    end
    histogram(steady_states, nbins=21, normed=true)
    scatter!(1:40, x_true)
    xlabel!("x")
    ylabel!("P(x)")
    savefig("network1.svg")
end

function simulate_network(k_1, k_2)
    n_steps = 300
    x = zeros(n_steps)
    t = zeros(n_steps)
    x[1] = rand( [0, 50], Int32)
    t[1] = 0

    for i in 2:n_steps
        prop_1 = k_1  
        prop_2 = k_2 * x[i-1]
        a = prop_1 + prop_2

        R = rand()
        dt = 1/a*log(1/(1-rand()))
        if R < prop_1/a
            x[i] = x[i-1] + 1.
        else
            x[i] = x[i-1] - 1.
        end
        t[i] = t[i-1] + dt
    end
    return x, t
end

main()
