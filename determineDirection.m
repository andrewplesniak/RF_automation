function [direction] = determineDirection(direction, currentPositionIndex, numPositions)
%turns direction around if at end of position array
    if direction == 1 || direction == 0
        if currentPositionIndex >= numPositions
            if  direction == 0
                direction = -1;
            else
                direction = 0;
            end
        end
    end
    if direction == -1 || direction == 0
        if currentPositionIndex <= 1
            if  direction == 0
                direction = 1;
            else
                direction = 0;
            end
        end        
    end

end

