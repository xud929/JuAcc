
function Base.show(io::IO, mag::T) where T <: Union{AbstractElement,AbstractBeam}
    names=fieldnames(typeof(mag))
    println(io,typeof(mag))
    for i = 1:length(names)
        println(io,lpad(names[i],12," ")*"  :  $(getfield(mag,names[i]))")
    end
    return
end

function Base.show(io::IO, seq::Sequence)
    names=getNames(seq)
    types=getTypes(seq)
    ret=String[]
	index=0
	println(io,typeof(seq))
    for (name,type) in zip(names,types)
		index+=1
        temp=isempty(name) ? "$(type)" : "$(name):$(type)"
		push!(ret,"$(index)\t$(temp)")
    end 
    join(io,ret,"\n")
end


function Base.show(io::IO, twi::T) where {T <: Union{DecoupledTwiss,RipkenTwiss,EdwardsTengTwiss}}
	println(io,typeof(twi))
	for name in fieldnames(typeof(twi))
		println(io,lpad(name,12," ")*" : $(getfield(twi,name))")
	end
end
