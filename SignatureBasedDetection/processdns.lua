function init (args)
   local needs = {}
   needs["payload"] = tostring(true)
   return needs
end

function match(args)
    text = tostring(args["payload"])
    if #text > 0 then
	    --print (a)
	    url,garbage,com = text:match("(%w+)(%c)(%w+)%z")
	    --print (x)
	    --print (y)
	    text = (url .. com)
	    --print ("domain")
	    --print(a)
	    --a = string.gsub(a, "%.", "")
	    maxentropy = log2(text:len())
	    --print ("max entropy")
	    --print (maxentropy)
	    --print ("entropy returned")
	    --print (entropy(a))
	    entropyholder = entropy(text)
	    --print ("85 entropy")
	    perentropy = (.85 * maxentropy)
	    --print (perentropy)
            if((entropyholder > 3) and (entropyholder >= perentropy)) then
              --print("here")
	      return 1
	    else
	      return 0
            end

    end
    return 0
end



function log2 (x) return math.log(x) / math.log(2) end
 
function entropy (args)
    --args = toString(args["payload"])
    --args = string.find(args,"^%w+://([^/]+)")
    --print (args)
    --args = string.gsub(args, "%.", "")
    --print (args)
    --maxentropy = log2(args:len())
    local N, count, sum, i = args:len(), {}, 0
    for char = 1, N do
        i = args:sub(char, char)
        if count[i] then
            count[i] = count[i] + 1
        else
            count[i] = 1
        end
    end
    for n_i, count_i in pairs(count) do
        sum = sum + count_i / N * log2(count_i / N)
    end
    return -sum

   -- if -sum > 3 and .85*maxentropy then
--	    return 1
  --  else
--	    return 0
  --  end
end


