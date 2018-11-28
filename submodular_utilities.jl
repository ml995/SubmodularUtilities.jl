# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

module SubmodularUtilities
export lazy_greedy, pipage_round

using Base.Order
using DataStructures
function lazy_greedy(f, ground_set, k)
    uppers = [(Inf, i) for i in ground_set]
    myorder = ReverseOrdering(By(x->x[1]))
    heapify!(uppers, myorder)
    s = []
    current = 0.
    for i in 1:k
        while true
            v, e = heappop!(uppers, myorder)
            new_upper_bound = f(vcat(s, e)) - current
            if new_upper_bound >= uppers[1][1]
                push!(s, e)
                current += new_upper_bound
                break
            else
                heappush!(uppers, (new_upper_bound, e), myorder)
            end
        end
    end
    return s
end

function pipage_round(x)
    function pipage_round_raw(x)
        y = copy(x)
        T = []
        for i in 1:length(y)
            if 0 < y[i] < 1
                push!(T, i)
            end
        end
    
        try
            while length(T) > 0
                i, j = T[1], T[2]
                if y[i] + y[j] < 1
                    p = y[j] / (y[i] + y[j])
                    if rand() < p
                        y[j] += y[i]
                        y[i] = 0.
                        deleteat!(T, 1)
                    else
                        y[i] += y[j]
                        y[j] = 0.
                        deleteat!(T, 2)
                    end
                else
                    p = (1. - y[i]) / (2. - y[i] - y[j])
                    if rand() < p
                        y[i] += y[j] - 1.
                        y[j] = 1.
                        deleteat!(T, 2)
                        if y[i] == 0.
                            deleteat!(T, 1)
                        end
                    else
                        y[j] += y[i] - 1.
                        y[i] = 1.
                        deleteat!(T, 1)
                        if y[j] == 0.
                            deleteat!(T, 1)
                        end
                    end
                end
            end
        catch
            return y
        end
        return y
    end

    function regularize_answer(ans)
        pp = pipage_round_raw(ans)
        pp[pp .< 1] = 0.
        return pp
    end
    px = regularize_answer(x)
    v = [i for i in 1:length(x) if px[i] != 0]
    return v
end
end