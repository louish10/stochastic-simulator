using Plots

function main()
    n_simulations = 500000
    steady_states = zeros(n_simulations)
    for i in 1:n_simulations
        x, t = simulate_network(5, 0.3)
        steady_states[i] = x
        println(i)
    end
    x_true = zeros(40)
    for i in 1:40
        x_true[i] = (1/factorial(big(i))*(5/0.3)^i * exp(-5/0.3))
    end

    nbins = Int(maximum(steady_states))
    println(nbins)
    histogram(steady_states, nbins=Int(nbins), normed=true)
    scatter!(1:40, x_true)
    xlabel!("x")
    ylabel!("P(x)")
    savefig("../network1.svg")
end


function simulate_network(k_1, k_2)
    t_final = 500
    x = rand(1:50)
    t = 0

    while t < t_final
        x_last = x
        prop_1 = k_1  
        prop_2 = k_2 * x_last
        a = prop_1 + prop_2

        R = rand()
        dt = 1/a*log(1/(1-rand()))
        if R < prop_1/a
            x = x_last + 1.
        else
            x = x_last - 1.
        end
        t = t + dt
    end
    return x, t
end
main()
