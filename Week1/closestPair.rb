include Math

def generateInputArray size
	arr = []
	
	size.times do
		x = rand(10000)
		y = rand(10000)
		arr.push [x,y]
	end

	return arr
end

def eucDist a, b
	return sqrt( (a[0] - b[0]) ** 2 + (a[1] - b[1]) ** 2 )
end

# returns array of closest points (p, q) and distance bethween them
def closestPair pX, pY

	if pX.size == 2
		return [ pX[0], pX[1], eucDist( pX[0], pX[1] ) ]
	end

	if pX.size == 3
		d01 = eucDist( pX[0], pX[1] )
		d02 = eucDist( pX[0], pX[2] )
		d12 = eucDist( pX[1], pX[2] )

		return [ pX[0], pX[1], d01 ] if d01 <= d02 && d01 <= d12
		return [ pX[0], pX[2], d02 ] if d02 <= d01 && d02 <= d12
		return [ pX[1], pX[2], d12 ] if d12 <= d01 && d12 <= d02
	end

	# divide
	qX, rX = pX.each_slice( (pX.size/2.0).round ).to_a

	# Y arrays consist of sorted by Y points of corresponding X arrays
	qY = []; rY = []
	# x bar
	xB = qX.last

	for p in pY
		if p[0] < xB[0]
			qY.push p
		else
			rY.push p
		end
	end

	# conquer
	p1q1d = closestPair qX, qY
	p2q2d = closestPair rX, rY

	# pX is not needed in closestSplitPair, but x bar used twice
	p3q3d = closestSplitPair pY, xB, [ p1q1d[2], p2q2d[2] ].min

	# no split pairs better
	if p3q3d[2] == -1
		p3q3d[2] = p1q1d[2] + 1
	end

	return p1q1d if p1q1d[2] <= p2q2d[2] && p1q1d[2] <= p3q3d[2]
	return p2q2d if p2q2d[2] <= p1q1d[2] && p2q2d[2] <= p3q3d[2]
	return p3q3d if p3q3d[2] <= p1q1d[2] && p3q3d[2] <= p2q2d[2]
end

def closestSplitPair pY, xB, delta

	# exclude anything but vertical strip
	for y in pY
		if y[0] < ( xB[0] - delta ) || y[0] > ( xB[0] + delta )
			pY -= y
		end
	end

	itMax = [ pY.size - 8, 0 ].max
	pointsMax = [ 7, pY.size - 1 ].min

	res = [ 0, 0, -1 ]

	if pY.size > 1
		for i in 0..itMax
			for j in 1..pointsMax
				# ignore points of the same side of xB
				next if pY[i][0] < xB[0] && pY[ i + j ][0] < xB[0]
				next if pY[i][0] > xB[0] && pY[ i + j ][0] > xB[0]
				
				dist = eucDist( pY[i], pY[ i + j ] )
				if dist < delta
					delta = dist
					res = [ pY[i], pY[ i + j ], delta ]
				end
			end
		end
	end

	return res
end

# main
p = generateInputArray 1000

puts "Input array: #{p.inspect}"

pX = p.sort { |x,y| x[0] <=> y[0] }
pY = p.sort { |x,y| x[1] <=> y[1] }

res = closestPair pX, pY
puts "p = #{res[0].inspect}, q = #{res[1].inspect}, dist = #{res[2]}"
