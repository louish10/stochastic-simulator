using Plots

function main()
    n_simulations = 500000
    steady_states = zeros(n_simulations)
    for i in 1:n_simulations
        x, t = simulate_network(2.0, 4.8, 6.0, 0.4)
        steady_states[i] = x
        println(i)
    end
    nbins = Int(maximum(steady_states))
    histogram(steady_states, nbins=nbins, normed=true)
    p, x = analytic_solution(2.0, 4.8, 6.0, 0.4)
    xlabel!("x")
    ylabel!("P(x)")
    scatter!(x, p)
    savefig("network2.svg")
end


function simulate_network(k_1, k_2, k_3, k_4)
    t_final = 1000
    x = rand(1:30)
    t = 0

    while t < t_final
        prop_1 = k_1
        prop_2 = k_2 * x
        prop_3 = k_3 * x * (x - 1)
        prop_4 = k_4 * x * (x - 1) * (x - 2)
        a = prop_1 + prop_2 + prop_3 + prop_4

        R = rand()
        dt = 1. / a*log(1. /(1. - rand()))

        t += dt
        if t>t_final
            break
        end
        if R < prop_1/a
            x += 1
        elseif R < (prop_1+prop_2)/a
            x -= 1
        elseif R < (prop_1+prop_2+prop_3)/a
            x += 1
        else
            x -= 1
        end
    end
    return x, t
end

function analytic_solution(k1, k2, k3, k4)
    ps = zeros(31)
    xs = 0:30

    p0_recip = 0

    for x in 0:300
        p0_recip += analytic_p_x_over_p_0(x, k1, k2, k3, k4)
    end

    p0 = 1/p0_recip

    for x in xs
        ps[x+1] = p0*analytic_p_x_over_p_0(x, k1, k2, k3, k4)
    end


    return ps, xs
end

function analytic_p_x_over_p_0(x, k1, k2, k3, k4)
    px = 1
    for z in 1:x
        px *= (k1 + k3*(z-1)*(z-2))/(k2*z + k4*z*(z-1)*(z-2))
    end
    return px
end

main()
