require "test_helper"


class TestSamplePrograms < Befunge::TestCase
  setup do
    @befunge = Befunge::Interpreter.new
    @program = nil
  end

  test "hello world" do
    @program = <<END_PROGRAM
                 v
>v"Hello world!"0<
,:
^_25*,@
END_PROGRAM

    parse
    run!

    assert_equal "Hello world!\n", @befunge.output
  end

  test "rand15" do
    @program = <<END_PROGRAM
12481> #+?\# _.@
END_PROGRAM

    parse

    16.times do
      run!
      assert_equal true, (0..15).to_a.include?(output.to_i)
      reset
    end
  end


  test "pi" do
    pi = "3141592653589793238462643383279502884197169399375105820974944592307816406286208998628034825342117067"
    @program = <<END_PROGRAM
"^a&EPm=kY}t/qYC+i9wHye$m N@~x+"v
"|DsY<"-"z6n<[Yo2x|UP5VD:">:#v_@>
-:19+/"0"+,19+%"0"+,      ^  >39*
END_PROGRAM

    parse
    run!

    assert_equal pi, output
  end


  test "ASCII table" do
    @program = <<END_PROGRAM
25*3*4+>:."=",:,"   "v
       |-*2*88:+1,,, <
       @
END_PROGRAM
    @output = <<END_OUTPUT
34=\"   35=#   36=$   37=%   38=&   39='   40=(   41=)   42=*   43=+   44=,   45=-   46=.   47=/   48=0   49=1   50=2   51=3   52=4   53=5   54=6   55=7   56=8   57=9   58=:   59=;   60=<   61==   62=>   63=?   64=@   65=A   66=B   67=C   68=D   69=E   70=F   71=G   72=H   73=I   74=J   75=K   76=L   77=M   78=N   79=O   80=P   81=Q   82=R   83=S   84=T   85=U   86=V   87=W   88=X   89=Y   90=Z   91=[   92=\\   93=]   94=^   95=_   96=`   97=a   98=b   99=c   100=d   101=e   102=f   103=g   104=h   105=i   106=j   107=k   108=l   109=m   110=n   111=o   112=p   113=q   114=r   115=s   116=t   117=u   118=v   119=w   120=x   121=y   122=z   123={   124=|   125=}   126=~   127=\177   
END_OUTPUT

    parse
    run!
    assert_equal @output.chomp, output
  end


  test "beer" do
    @program = <<END_PROGRAM
92+9*                           :. v  <
>v"bottles of beer on the wall"+910<
,:
^_ $                             :.v
            >v"bottles of beer"+910<
            ,:
            ^_ $                     v
>v"Take one down, pass it around"+910<
,:
^_ $                           1-v
                                 :
        >v"bottles of beer"+910.:_          v
        ,:
        ^_ $                          ^
                    >v" no more beer..."+910<
                    ,:
                    ^_ $$ @
END_PROGRAM

    parse
    run!

    assert_equal 396, output.split(/\n/).size
  end


  test "selflis2" do
    @program = <<END_PROGRAM
">:#,_66*2-,@This prints itself out backwards......  but it has to be 80x1 cells
END_PROGRAM

    parse
    run!

    assert_equal @program.chomp.reverse, output
  end


  test "quine" do
    @program = ':0g,:93+`#@_1+'

    parse
    run!

    assert_equal @program, output
  end


  test "factorial" do
    @program = <<END_PROGRAM
                                    v
>v"Please enter a number (1-16) : "0<
,:             >$*99g1-:99p#v_.25*,@
^_&:1-99p>:1-:!|10          < 
         ^     <
END_PROGRAM

    parse
    run! :int_input => [6]

    assert_equal "Please enter a number (1-16) : 720\n", output
  end
end
