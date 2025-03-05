function plot(ax,s0::Float64,mag::Quadrupole;height=0.8,color="r")
    s1=s0+refS(mag)
    if mag.K1>0.0
        h1,h2=height,0.0
    elseif mag.K1<0.0
        h1,h2=0.0,-height
	else
        h1,h2=height/4,0.0
    end
    xx=[s0,s1,s1,s0,s0]
    yy=[h1,h1,h2,h2,h1]
    ax.fill(xx,yy,color=color)
    ax.plot(xx,yy,color=color)
    return s1
end

function plot(ax,s0::Float64,mag::Union{Drift,Monitor,HMonitor,VMonitor,Monitor,HKicker,VKicker,Kicker};color="k")
    s1=s0+refS(mag)
    ax.plot([s0,s1],[0.0,0.0],color=color)
    return s1
end

function plot(ax,s0::Float64,mag::Placeholder;color="g",height=0.2)
    s1=s0+refS(mag)
    h1=height/2.0
    h2=-h1
    xx=[s0,s1,s1,s0,s0]
    yy=[h1,h1,h2,h2,h1]
    ax.fill(xx,yy,color=color)
    ax.plot(xx,yy,color=color)
    return s1
end

function plot(ax,s0::Float64,mag::AbstractBend;height=1.0,color="b")
    s1=s0+refS(mag)
    h1=height/2.0
    h2=-h1
    xx=[s0,s1,s1,s0,s0]
    yy=[h1,h1,h2,h2,h1]
    ax.fill(xx,yy,color=color)
    ax.plot(xx,yy,color=color)
    return s1
end

function plot(ax,s0::Float64,mag::Union{Marker,ThinMultipole})
    #ax.plot(s0,0.0,color=color,ms=20,kwargs...)
    return s0
end
                                                                                                                            
function plot(ax,s0::Float64,mag::ThinQuad)
    return s0
end

function plot(ax,s0::Float64,mag::ThinKicker;height=1.0,color="k")
    s1=s0+refS(mag)
    if mag.HKick!=0.0 || mag.VKick!=0.0
        ax.annotate("", xy=(s0, 0.0), xytext=(s1, 1.0),arrowprops=Dict("arrowstyle"=>"->"),color=color)
    end
    return s1
end


function plot(ax,s0::Float64,seq::Sequence)
    for mag in seq.Line
		s0=plot(ax,s0,mag)
    end
	return s0
end

plot(ax,seq::Sequence)=begin
	ax.spines["top"].set_visible(false)
    ax.spines["right"].set_visible(false)
    ax.spines["bottom"].set_visible(false)
    ax.spines["left"].set_visible(false)
    ax.get_xaxis().set_ticks([])
    ax.get_yaxis().set_ticks([])
	plot(ax,0.0,seq)
end
