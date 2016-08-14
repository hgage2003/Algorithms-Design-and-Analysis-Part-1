def Merge arr1, arr2

	res = []

	while true do
		
		if ( arr1.size == 0 )
			res += arr2
			return res
		end

		if ( arr2.size == 0 )
			res += arr1
			return res
		end

		if ( arr1[0] <= arr2[0] )
			res.push arr1.shift
		else
			res.push arr2.shift
			$counter += arr1.size
		end

	end

	return res
end

def MergeSort arr
	
	if ( arr.size == 1 )
		return arr
	end

	if ( arr.size == 2 )
		if ( arr[0] > arr[1] )
			$counter += 1
			return [ arr[1], arr[0] ]
		else
			return arr
		end
	end

	left, right = arr.each_slice( (arr.size/2.0).round ).to_a
	
	left = MergeSort(left)
	right = MergeSort(right)

	return Merge(left, right)
end

arr = []

File.open('./IntegerArray.txt', 'r') do |numbers|
	while s = numbers.gets do
		arr.push s.strip.to_i
	end
end

$counter = 0
#puts MergeSort(arr).to_s
MergeSort arr
puts "#{$counter} inversions"