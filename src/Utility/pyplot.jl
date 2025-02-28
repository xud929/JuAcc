function plot(ax,s0::Float64,mag::Quadrupole;height=0.8,color="r")
    s1=s0+refS(mag)
    if mag.K1>=0.0
        h1,h2=height,0.0
    else
        h1,h2=0.0,-height
    end
    xx=[s0,s1,s1,s0,s0]
    yy=[h1,h1,h2,h2,h1]
    ax.fill(xx,yy,color=color)
    ax.plot(xx,yy,color=color)
    return s1
end

function plot(ax,s0::Float64,mag::Union{Drift,Monitor,HMonitor,VMonitor,Monitor,HKicker,VKicker,Kicker,Placeholder};color="k")
    s1=s0+refS(mag)
    ax.plot([s0,s1],[0.0,0.0],color=color)
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

function plot(ax,seq::Sequence)
    s0=0.0
    for mag in seq.Line
        s0=plot(ax,s0,mag)
    end
end
