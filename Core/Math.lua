Math = {}

Math.getAngleOfTwoPoints = function(t1, t2)
    return math.atan2(
        t1.x - t2.x,
        t1.y - t2.y
    )
end
