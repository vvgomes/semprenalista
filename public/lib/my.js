Number.prototype.times = function(f) {
  for(var i = 0; i < this; i++)
    f(i);
};

Array.prototype.has = function(e) {
  for(var i = 0; i < this.length; i++)
    if((e.equals) ? e.equals(this[i]) : e === this[i])
      return true;
  return false;
};

Array.prototype.filter = function(f) {
	var filtered = [];
		for(var i = 0; i < this.length; i++)
			f(this[i], i) && filtered.push(this[i]);
		return filtered;
};

Array.prototype.without = function(other) {
	var result = [];
	for(var i = 0; i < this.length; i++)
		if(!other.has(this[i]))
			result.push(this[i]);
	return result;
};

Array.prototype.random = function() {
	return this[Math.floor((this.length-1)*Math.random())];
};
