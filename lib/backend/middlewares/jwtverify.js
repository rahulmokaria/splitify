const helper=require('../utils/helper')
const {usermodel}=require('../model/user.model')
const {shopkeepermodel}=require('../model/shopkeeper.model')
const jwt=require('jsonwebtoken')
const verifier=async (req,res,next)=>{
    try {
        const {token}=req.body;
        if(!token) return helper(res,"Invalid request",404,false);
        const result=await jwt.verify(token,process.env.JWT_KEY);
        if(result){
            if(result.isuser==true){
                const check=await usermodel.findOne({_id:result.userid})
                if(!check){
                    return helper(res,"User not exist",404,false);
                }
                req.body.userid=result.userid;
                next();
            }
            else{
                const check=await shopkeepermodel.findOne({_id:result.userid});
                if(!check) return helper(res,"Shopkeeper not exist",404,false);
                req.body.userid=result.userid;
                next();
            }
        }
        else{
            return helper(res,"Invalid token",404,false);
        }
    } catch (error) {
        return helper(res,error.message,500,false);
    }
}

module.exports={verifier};