
using CSV, DataFrames
using StatsBase, Statistics
using PyPlot
using Plots


#mdf = CSV.read(ARGS[1], header=["frame", "horse", "X", "Y"])
#c = countmap(mdf.horse)


#j = 0
#for h in keys(c)
#	global j += 1
#	if j % 20 == 0
#		i = mdf.horse .== h
#		PyPlot.plot(mdf.X[i], mdf.Y[i])
#	end
#end
#
#
#h = collect(keys(c))[1]
#i = mdf.horse .== h
#X = mdf.X[i]
#Y = mdf.Y[i]
#j = 1:length(X)
#PyPlot.plot(X[j], Y[j])
#PyPlot.scatter(X[j], Y[j])


function dist(x1, y1, x2, y2)
	return sqrt((x2-x1)^2 + (y2-y1)^2)
end
function steps(X::Array{Float64,1}, Y::Array{Float64,1})
	l = length(X)
	s = Float64[]
	for i in 2:l
		d = sqrt((X[i] - X[i-1])^2 + (Y[i] - Y[i-1])^2)
		push!(s, d)
	end
	return s
end


function dist2(x1, y1, x2, y2)
	(x2-x1)^2 + (y2-y1)^2
end
function dir3(X::Array{Float64,1}, Y::Array{Float64,1})
	x = X .- X[1]
	y = Y .- Y[1]
	phi = atan(y[2], x[2])
	xp = x .* cos.(phi) .+ y .* sin.(phi)
	yp = -x .* sin.(phi) .+ y .* cos.(phi)
	a2 = dist2(xp[1], yp[1], xp[2], yp[2])
	b2 = dist2(xp[2], yp[2], xp[3], yp[3])
	c2 = dist2(xp[1], yp[1], xp[3], yp[3])
	cg = (a2+b2-c2)/(2*sqrt(a2*b2))
	if -1 <= cg <= 1
		gamma = pi - acos(cg)
		if yp[3] < 0
			return -gamma
		else
			return gamma
		end
	else
		return 0.0
	end
end
function directions(X::Array{Float64,1}, Y::Array{Float64,1})
	l = length(X)
	s = Float64[]
	push!(s, 0.0)
	for i in 2:(l-1)
		j = (i-1):(i+1)
		gamma = dir3(X[j], Y[j])
		push!(s, gamma)
	end
	return s
end


function distmatrix(X1, Y1, X2, Y2)
	l1 = length(X1)
	l2 = length(X2)
	m = zeros(l1, l2)
	for i1 in 1:l1
		for i2 in 1:l2
			m[i1, i2] = dist(X1[i1], Y1[i1], X2[i2], Y2[i2])
		end
	end
	return m
end


function dirmatrix(X1, Y1, X2, Y2)
	l1 = length(X1)
	l2 = length(X2)
	m = zeros(l1, l2)
	for i1 in 1:l1
		for i2 in 1:l2
			m[i1, i2] = atan(Y2[i2] - Y1[i1], X2[i2] - X1[i1])
		end
	end
	return m
end


function calcavgshift(m2, dm)
	l1, l2 =size(m2)
	is = zeros(Int64, l1)
	for i in 1:l1
		d1, i1 = findmin(m2[i,:])
		d2, i2 = findmin(m2[:,i1])
		if i == i2
			is[i] = i1
		else
			dmins = []
			dmin = 1e6
			minj = 0
			for j in 1:l2
				dj, jj = findmin(m2[:,j])
				if jj == i && dj < dmin
					dmin = dj
					minj = j
				end
			end
			is[i] = minj
		end
	end
	distances = Float64[]
	angles = Float64[]
	for i in 1:l1
		is[i] <= 0 && continue
		push!(distances, m2[i, is[i]])
		push!(angles, dm[i, is[i]])
	end
	return median(distances), median(angles)
end


function procmatrix(m2)
	l1, l2 =size(m2)
	is = zeros(Int64, l1)
	count = 0
	while sum(is .== 0) > 0 && count < l1
		count += 1
		for i in 1:l1
			is[i] > 0 && continue
			d1, i1 = findmin(m2[i,:])
			d2, i2 = findmin(m2[:,i1])
			if i == i2
				is[i] = i1
				m2[i,:] .= 1e6
				m2[:,i1] .= 1e6
			end
		end
	end
	r0 = findall(is .== 0)
	if length(r0) == 0 # all points sorted out
		println("all points sorted out")
		return is
	else # some ambiguities remained
		return nothing
	end
end


function expectedpoint(x, y, qdist, qangle)
	px = qdist * cos(qangle)
	py = qdist * sin(qangle)
	return x + px, y + py
end


function nextpoint(x, y)
	ds = steps(x, y)[2:end]
	as = directions(x,y)[2:end]
	ds = mean(ds)
	as = mean(as)
	a = atan(y[end] - y[end-1], x[end] - x[end-1])
	return expectedpoint(x[end], y[end], ds, a + as)
end


cresultant(a, degrees::Bool=false) = degrees ?
    sqrt(sum(sin.(deg2rad.(a)))^2 + sum(cos.(deg2rad.(a)))^2)/length(a) :
    sqrt(sum(sin.(a))^2 + sum(cos.(a))^2)/length(a)
cstd(a, degrees::Bool=false) = sqrt(-2*log(cresultant(a, degrees)))


function sortpoints(mdf; lag=4, nframes = nothing)
	frames = unique(mdf.frame)
	isnothing(nframes) && (nframes = length(frames))
	f = mdf.frame .== frames[1]
	X1 = mdf.X[f]
	Y1 = mdf.Y[f]
	nhorses = length(X1)
	Xs = zeros(nframes, nhorses)
	Ys = zeros(nframes, nhorses)
	Xs[1,:] .= X1
	Ys[1,:] .= Y1
	m2 = 0.0
	dm = 0.0
	is = 0
	for f in 2:nframes
		println(f)
		xp = zeros(nhorses)
		yp = zeros(nhorses)
		fi = mdf.frame .== f
		xf = mdf.X[fi]
		yf = mdf.Y[fi]
		if f <= lag
			m2 = distmatrix(Xs[f-1,:], Ys[f-1,:], xf, yf)
			dm = dirmatrix(Xs[f-1,:], Ys[f-1,:], xf, yf)
			qd, qa = calcavgshift(m2, dm)
			for i in 1:nhorses
				xp[i], yp[i] = expectedpoint(Xs[f-1,i], Ys[f-1,i], qd, qa)
			end
		else
			for i in 1:nhorses
				xp[i], yp[i] = nextpoint(Xs[(f-lag):(f-1),i], Ys[(f-lag):(f-1),i])
			end
		end
		m2 = distmatrix(xp, yp, xf, yf)
		is = procmatrix(m2)
		for i in 1:length(is)
			Xs[f,i] = xf[is[i]]
			Ys[f,i] = yf[is[i]]
		end
	end
	return Xs, Ys
	#return is, m2
end


function getpath(ID::String, mdf)
	X = mdf.X[mdf.horse .== ID]
	Y = mdf.Y[mdf.horse .== ID]
	return X, Y
end
function getpath(id::Int, mdf)
	h = mdf.horse[mdf.frame .== 1][id]
	return getpath(h, mdf)
end


function deviance(Xs, Ys, mdf)
	#Xs, Ys = sortpoints(mdf)
	nframes, nhorses = size(Xs)
	diffhorses = Int[]
	totaldiff = 0
	for h in 1:nhorses
		x, y = getpath(h, mdf)
		dx = sum(Xs[:,h] .- x)
		dy = sum(Ys[:,h] .- y)
		d = abs(dx + dy)
		if d > 0.0
			push!(diffhorses, h)
			totaldiff += d
		end
	end
	if length(diffhorses) > 0
		return diffhorses, totaldiff/length(diffhorses)
	else
		return nothing, nothing
	end
end


function showtimeslot(nframe, mdf)
	gdf = groupby(mdf, :frame)
	fdf = gdf[nframe]
	for i in 1:nrow(fdf)
		PyPlot.scatter(fdf.X[i], fdf.Y[i])
		PyPlot.text(fdf.X[i], fdf.Y[i], fdf.horse[i], fontsize="xx-small")
	end
end


function myscatter(pointi, frame, mdf)
	typeof(pointi) == Int64 && (pointi = [pointi])
	horses = unique(mdf.horse[mdf.frame .== 1])
	horses = horses[pointi]
	gmdf = groupby(mdf, :frame)
	df = gmdf[frame]
	for h in horses
		j = (1:nrow(df))[df.horse .== h]
		PyPlot.scatter(df.X[j], df.Y[j])
		PyPlot.text(df.X[j], df.Y[j], string(h), fontsize="xx-small")
	end
end


function shownextmove(id, f, mdf; lag=4)
	l = lag - 1
	Hs = mdf.horse[mdf.frame .== 1][id]
	for h in Hs
		x = mdf.X[mdf.horse .== h][(f-l):f]
		y = mdf.Y[mdf.horse .== h][(f-l):f]
		PyPlot.scatter(x, y)
		PyPlot.plot(x, y)
		xn, yn = nextpoint(x, y)
		PyPlot.scatter(xn, yn)
		xr = mdf.X[mdf.horse .== h][(f+1)]
		yr = mdf.Y[mdf.horse .== h][(f+1)]
		PyPlot.scatter(xr,yr)
		PyPlot.plot([x[end], xn], [y[end], yn], "--", label="predicted")
		PyPlot.plot([x[end], xr], [y[end], yr], "-.", label="real")
		legend()
	end
end


#Xs, Ys = sortpoints(mdf)
#PyPlot.plot(Xs[:,10], Ys[:,10])
#x, y = getpath(10, mdf)
#PyPlot.plot(x,y)


#devhorses, d = deviance(Xs, Ys, mdf)

#println("We have problems with ", length(devhorses), "horses")

#figure()
#subplot(1,2,1)
#PyPlot.plot(Xs[:,2], Ys[:,2])
#x, y = getpath(2, mdf)
#PyPlot.plot(x,y)
#subplot(1,2,2)
#PyPlot.plot(Xs[:,3], Ys[:,3])
#x, y = getpath(3, mdf)
#PyPlot.plot(x,y)
#tight_layout()
#
#
#i = 1950:1970
#figure()
#subplot(1,2,1)
#x, y = getpath(2, mdf)
#PyPlot.plot(x[i],y[i])
#for j in i
#	myscatter(2, j, mdf)
#end
#PyPlot.plot(Xs[i,2], Ys[i,2])
#axis("equal")
#subplot(1,2,2)
#x, y = getpath(3, mdf)
#PyPlot.plot(x[i],y[i])
#for j in i
#	myscatter(3, j, mdf)
#end
#PyPlot.plot(Xs[i,3], Ys[i,3])
#axis("equal")
#tight_layout()
#
#
#figure()
#shownextmove([2,3], 1955, mdf)
#myscatter(2, 1955, mdf)
#myscatter(3, 1955, mdf)
#tight_layout()
#
#
#dhs = Dict()
#dhs[4] = devhorses
#for i in 5:7
#	xs, ys = sortpoints(mdf, lag=i)
#	dh, d = deviance(xs, ys, mdf)
#	dhs[i] = dh
#end
#
#
#for i in keys(dhs)
#	println("lag=", i, ": ", length(dhs[i]))
#end
#
#
#Xs, Ys = sortpoints(mdf, lag=5)
#
#
#figure()
#x, y = getpath(204, mdf)
#PyPlot.plot(x, y)
#PyPlot.plot(Xs[:,204], Ys[:,204])
#figure()
#i = 3000:3050
#PyPlot.plot(x[i], y[i])
#PyPlot.plot(Xs[i,204], Ys[i,204])
#hs = ["H115", "H274", "H158"]
#for h in hs
#	x, y = getpath(h, mdf)
#	PyPlot.plot(x[i], y[i])
#end
#myscatter(206, 3025, mdf)
#myscatter(204, 3025, mdf)
#myscatter(215, 3025, mdf)
#
#
#ds = Dict()
#dis = Dict()
#for h in unique(mdf.horse[mdf.frame .== 1])
#	x, y = getpath(h, mdf)
#	ds[h] = steps(x, y)
#	dis[h] = directions(x, y)
#end
#
#
#mX = map((x) -> mean(mdf.X[mdf.frame .== x]), unique(mdf.frame))
#mY = map((x) -> mean(mdf.Y[mdf.frame .== x]), unique(mdf.frame))
#md = steps(mX, mY)
#mdi = directions(mX, mY)
#figure()
#for h in keys(ds)
#	PyPlot.plot(ds[h], linewidth=0.2)
#end
#PyPlot.plot(md)
#figure()
#for h in keys(dis)
#	PyPlot.plot(abs.(dis[h]), linewidth=0.2)
#end
#PyPlot.plot(mdi)
#
#
#i = 30
#close("all")
#h1 = collect(keys(c))[i]
#i1 = mdf.horse .== h1
#X1 = mdf.X[i1]
#Y1 = mdf.Y[i1]
#xc, yc = closest(h1, mdf, limit=2.0)
##j = 750:780
#j = 1:nframe
#PyPlot.plot(X1[j], Y1[j])
#PyPlot.plot(xc[j], yc[j], "--")
#
#
#f = mdf.frame .== 764
#PyPlot.scatter(mdf.X[f], mdf.Y[f], s=4)
#xlim((1100,1280))
#ylim((1260,1280))
#deviance(h1, mdf, nframe, limit=1.57)
#
#
#f = map((i) -> i in 1050:1150, mdf.frame)
#fdf = mdf[f,:]
#i1 = fdf.horse .== h1
#X1 = fdf.X[i1]
#Y1 = fdf.Y[i1]
#xc, yc = closest(h1, fdf, limit=2.0)
#PyPlot.plot(X1, Y1)
#PyPlot.plot(xc, yc, "--")
##axis("equal")
#xlim((1600,1660))
#ylim((1128,1139))
#frames = unique(fdf.frame)
#for f in 1:length(frames)
#	ff = fdf.frame .== frames[f]
#	PyPlot.scatter(fdf.X[ff], fdf.Y[ff])
#end
#
#
#h = collect(keys(c))[212]
#i = mdf.horse .== h
#X = mdf.X[i]
#Y = mdf.Y[i]
##X = [2.0, 1.0, -3.0]
##Y = [2.0, 0.0, -3.0]
#s = steps(X, Y)
#d = directions(X, Y)
##j = 1:length(unique(mdf.frame))
#j = 2001:2500
#jj = (minimum(j)):(maximum(j)-1)
##jj = (minimum(j)-1):(maximum(j)-1)
#figure()
#subplot(1,2,1)
#plot(jj, s[jj])
#plot(jj, d[jj], alpha=0.25)
#scatter(jj, d[jj], alpha=0.25)
#PyPlot.grid()
#subplot(1,2,2)
#PyPlot.plot(X[j], Y[j])
#PyPlot.scatter(X[j], Y[j], alpha=0.25)
#axis("equal")
#PyPlot.grid()
#tight_layout()
#subplot(2,1,1)
#plot(s)
#subplot(2,1,2)
#plot(d)
#tight_layout()
#scatter(s,d, s=1, alpha=0.25)
#tight_layout()
#
