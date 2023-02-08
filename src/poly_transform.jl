
using Polynomials

abstract type AbstractBlockFilter <: AbstractDaqFilter


struct LinearTransform{T,IC,OC} <: AbstractBlockFilter
    ichans::IC
    ochans::IC
    coefs::Matrix{T}
end

function LinearTransform(ichans::IC, ::Type{T}=Float64) where {T,IC}
    coefs = zeros(T, numchannels(ichans), 2)
    coefs[:,2] .= one(T)
    return LinearTransform{T,IC,IC}(ichans, ichans, coefs)
end

function LinearTransform(ichans::IC, ochans::OC, ::Type{T}=Float64) where {T,IC,OC}
    @assert numchannels(ichans) == numchannels(ochans)
    coefs = zeros(T, numchannels(ichans), 2)
    coefs[:,2] .= one(T)
    return LinearTransform{T,IC,IC}(ichans, ichans, coefs)
end

import Base.getindex
getindex(filt::LinearTransform, idx) = (filt.coefs[idx,1], filt.coefs[idx,2])

function daqfilter!(filt::LinearTransform, x::AbstractMatrix, y::AbstractMatrix)

    @assert size(x) == size(y)
    for k in 1:size(x,2)
        for i in 1:size(x,1)
            a₀, a₁ = filt[i]
            y[i,k] = a₀ + a₁*x[i,k]
        end
    end
    return y
end


daqfilter(filt::LinearTransform{T1}, x::AbstractMatrix{T2}) =
    daqfilter!(filt, x, zeros(promote_type{T1,T2}, size(x)...))

function daqfilter!(filt::LinearTransform, x::MeasData, y::MeasData)
    daqfilter!(filt, measdata(x), measdata(y))
    return y
end

function daqfilter(filt::LinearTransform{T1}, x::MeasData{T2})
    xdata = measdata(x)
    ydata = zeros(promote_type(T1,T2), size(xdata)...)
    daqfilter!(filt, xdata, ydata)

    
    return MeasData(x.devname, x.devtype, x.sampling, ydata, filt.ochans)
    
end

    
            
struct PolyTransform{T,IC,OC} <: AbstractBlockFilter
    ichans::IC
    ochans::IC
    coefs::Matrix{T}
end

    
