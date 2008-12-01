module BefungeTestHelper
  def stack_data
    @befunge.stack.data
  end
  
  def pc
    @befunge.pc
  end
  
  def parse(program)
    @befunge.parse(program)
  end
  
  def step(n = 1)
    @befunge.step(n)
  end
  
  def pc_coord
    [pc.row, pc.col]
  end
end