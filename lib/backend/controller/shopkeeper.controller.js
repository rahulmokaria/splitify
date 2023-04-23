const {shopkeepermodel}=require('../model/shopkeeper.model')
const helper=require('../utils/helper')
const bcrypt=require('bcrypt')
const validator=require('email-validator')
const jwt=require('jsonwebtoken')
const registercontroller=async (req,res)=>{
   try {
    console.log(req.body)
    const {email,name,password}=req.body;
    if(!validator.validate(email)) return helper(res,"Email is invalid",404,false)
    const check=await shopkeepermodel.findOne({email:email})
    if(check){
        return helper(res,"User already exist",409,false);
    }
    await shopkeepermodel.create({email,name,password});
    return helper(res,"Successfully created",200,true);
   } catch (error) {
    return helper(res,error.message,500,false)
   }
}


const logincontroller=async (req,res)=>{
    try {
        const {email,password}=req.body
        if(!validator.validate(email)) return helper(res,"Email/Password is invalid",404,false)
        const user=await shopkeepermodel.findOne({email:email})
        if(!user){
            return helper(res,"User not exist",404,false)
        }
        const result=await bcrypt.compare(password,user.password)
        if(!result) return helper(res,"Email/Password is invalid",404,false)
        const {_id}=user;
        const token=jwt.sign({userid:_id,isuser:false},process.env.JWT_KEY,{expiresIn:'15d'});
        return res.status(200).json({
            message:token,
            flag:true
        })
    } catch (error) {
        return helper(req,error.message,500,false)
    }
}
module.exports={registercontroller,logincontroller}