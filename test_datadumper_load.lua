
t = dofile("test.dump")

print (t)

for i,j in ipairs(t) do
	j()
end

