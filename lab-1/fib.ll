define i32 @fib(i32 noundef %0) #0 {
  %res_loc = alloca i32 
  %arg_loc = alloca i32 
  %pre0_loc = alloca i32 
  %pre1_loc = alloca i32 
  %tmp_loc=alloca i32
  %i_loc = alloca i32
  store i32 %0, i32* %arg_loc;保存参数 
  %arg = load i32,i32* %arg_loc
  %zero_cmp = icmp sle i32 %arg, 0
  br i1 %zero_cmp, label %zero_branch, label %init
;分配内存
zero_branch:                                               
  store i32 0, i32* %res_loc 
  br label %rtn
;返回n为0的情况
init:                                              
  store i32 0, i32* %tmp_loc
  store i32 0, i32* %pre0_loc 
  store i32 1, i32* %pre1_loc
  store i32 1, i32* %i_loc
  br label %stmt
;变量初始化
stmt:                                              
  %check_i = load i32, i32* %i_loc
  %end_cmp = icmp sle i32 %check_i, %arg
  br i1 %end_cmp, label %body, label %end_loop

body:                          
  %pre0=load i32, i32* %pre0_loc	  
  %pre1=load i32, i32* %pre1_loc

  %tmp = add nsw i32 %pre0, %pre1

  store i32 %pre1,i32* %pre0_loc
  store i32 %tmp, i32* %pre1_loc
  br label %inc

inc:                 
  %prei=load i32,i32* %i_loc
  %i = add nsw i32 %prei, 1
  store i32 %i, i32* %i_loc
  br label %stmt

end_loop:        
  %res_pre1=load i32 ,i32* %pre1_loc
  store i32 %res_pre1, i32* %res_loc 
  br label %rtn
rtn:           
  %res=load i32,i32* %res_loc
  ret i32 %res
}

define i32 @main() #0 {
  %a = call i32 (...) @getint()
  %b = call i32 @fib(i32 noundef %a)
  %err = call i32 (i32, ...) bitcast (i32 (...)* @putint to i32 (i32, ...)*)(i32 noundef %b)
  ret i32 0
}

declare i32 @getint(...) #1

declare i32 @putint(...) #1
