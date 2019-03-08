import Statistics.median

function correction(fin, fout)
	temp = split(read(fin, String), "\n")
	temp = temp[length.(temp) .> 0]
	c = temp[2:2:length(temp)]
	arrc = [Array{Char, 1}(str) for str in c]
	k = 7
	n = length(c[1])
	m = length(c)
	wo = zeros(n, m)
	for i in 1:n
		cnt = zeros(128)
		for j in 1:m
			cnt[UInt8(c[j][i])] += 1
		end
		cnt[UInt8('X')] = 0
		cnt[UInt8('-')] = 0
		unq = length([1 for t in cnt if t > 0])
		total = sum(cnt)
		for j in 1:m
			wo[i, j] = total == 0 ? 0 : total / (unq * cnt[UInt8(c[j][i])])
		end
	end
	w1 = [wo[:,j][(arrc[j] .!= '-') .& (arrc[j] .!= 'X')] for j in 1:m]
	w = [[median(arr[i:i+k-1]) for i in 1:length(arr)-k+1] for arr in w1]
	ws = [[sum(arr[i:i+k-1]) for i in 1:length(arr)-k+1] for arr in w1]
	wsorted = [sort(arr) for arr in w]
	wsum = [accumulate(+, arr) for arr in wsorted]
	f(x, y, n, m) = x^2 / n + (n == m ? 0 : (y - x)^2 / (m - n))
	var = [f.(arr, arr[end], 1:length(arr), length(arr)) for arr in wsum]
	iCutoff = [(i > 0.8 * length(arr) ? i : length(arr)) for arr in var for i in [findmax(arr)[2]]]
	wCutoff = [wsorted[j][iCutoff[j]] for j in 1:m]
	s = zeros(n - k + 1, m, 2)
	tiebreaker = zeros(n - k + 1, m, 2)
	bt = zeros(Int64, n - k + 1, m, 2)
	for j in 1:m
		wj = w[j]
		wsj = ws[j]
		L = length(wj)
		s = zeros(L, 2)
		tiebreaker = zeros(L, 2)
		bt = zeros(Int64, L, 2)
		cutoff = max(wCutoff[j], 3)
		for i in 1:L
			v = (wj[i] > cutoff ? 0 : 1)
			if i == 1
				s[i, 1] = v
				s[i, 2] = 1 - v
				tiebreaker[i, 1] = 0
				tiebreaker[i, 2] = wsj[i]
			else
				s[i, 1] = s[i - 1, 1] + v
				s[i, 2] = s[i - 1, 2] + 1 - v
				tiebreaker[i, 1] = tiebreaker[i - 1, 1]
				tiebreaker[i, 2] = tiebreaker[i - 1, 2] + wsj[i]
				bt[i, 1] = 1
				bt[i, 2] = 2
			end
			if i > k && (s[i, 1], tiebreaker[i, 1]) < (s[i - k, 2] + v, tiebreaker[i - k, 2])
				s[i, 1] = s[i - k, 2] + v
				tiebreaker[i, 1] = tiebreaker[i - k, 2]
				bt[i, 1] = 2
			end
			if i > k && (s[i, 2], tiebreaker[i, 2]) < (s[i - k, 1] + 1 - v, tiebreaker[i - k, 1])
				s[i, 2] = s[i - k, 1] + 1 - v
				tiebreaker[i, 2] = tiebreaker[i - k, 1] + wsj[i]
				bt[i, 2] = 1
			end
		end
		str = arrc[j][(arrc[j] .!= '-') .& (arrc[j] .!= 'X')]
		icur = L
		if s[L, 1] < s[L, 2]
			str[L:L+k-1] .= 'X'
			bcur = 2
		else
			bcur = 1
		end
		while true
			if bcur == 1 && bt[icur, bcur] == 1
				icur -= 1
				bcur = 1
			elseif bcur == 1 && bt[icur, bcur] == 2
				icur -= k
				bcur = 2
				str[icur : icur + k - 1] .= 'X'
			elseif bcur == 2 && bt[icur, bcur] == 1
				icur -= k
				bcur = 1
			elseif bcur == 2 && bt[icur, bcur] == 2
				icur -= 1
				bcur = 2
				str[icur] = 'X'
			elseif bcur == 1
				break
			else
				str[1:icur - 1] .= 'X'
				break
			end
		end
		println(fout, temp[2 * j - 1])
		i = 1
		for t in 1:length(c[j])
			if c[j][t] == 'X' || c[j][t] == '-'
				print(fout, c[j][t])
			else
				print(fout, str[i])
				i += 1
			end
		end
		println(fout)
	end
end

if (length(ARGS[1]) > 3 && ARGS[1][end-2:end] == ".fa") || (length(ARGS[1]) > 3 && ARGS[1][end-5:end] == ".fasta")
	correction(open(ARGS[1], "r"), stdout)
else
	temp = split(read(ARGS[1], String), "\n")
	temp = temp[length.(temp) .> 0]
	for i = 2:2:length(temp)
		correction(open(temp[i - 1], "r"), open(temp[i], "w"))
	end
end
