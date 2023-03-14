using Statistics

struct DaqStats{Fun} <: AbstractDaqFilter
    fun::Fun
end

DaqStats(fun::Fun) where {Fun <: Function} = DaqStats(fun, :, :)
DaqStats(fun::Function, chans::ICH) where {Fun<:Function,ICH,OCH} =
    DaqStats(fun,chans)


daqfilter(filt::DaqStats{Fun,Colon}, X::AbstractMatrix) where {Fun} =
    filt.fun(X, dims=2)

function daqfilter(filt::DaqStats{Fun,Colon},
                  X::MeasData{T,AT}) where {Fun,T,AT<:AbstractMatrix}
    xstats = filt.fun(X.data, dims=2)
    return MeasData(X.devname, X.devtype, X.sampling, xstats, X.chans)
end

daqfilter(filt::DaqStats{Fun,CH},
          X::AbstractMatrix) where {Fun,CH<:AbstractVector{<:Integer}} =
              return filt.fun(X[filt.chans], dims=2)

function daqfilter(filt::DaqStats{Fun,CH},
                   X::MeasData{T,AT,CH}) where {Fun,CH<:AbstractVector{<:Integer},
                                                T,AT<:AbstractMatrix} 
    
    @assert numchannels(filt.chans) == numchannels(X.chans)
    xstats = filt.fun(X.data[filt.chans], dims=2)
    
end

    

    

