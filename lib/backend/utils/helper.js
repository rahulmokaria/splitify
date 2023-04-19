const helper=async (res,message,code,flag)=>{
    try{
        return res.status(code).json({
            message:message,
            flag:flag
        })
    }
    catch (error) {
     console.log('Error at helper function'+error.message);
   }
}

module.exports=helper

