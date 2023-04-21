const {usermodel}=require('../model/user.model')
const {detailsmodel}=require('../model/userdetail.model')
const helper=require('../utils/helper')
const bcrypt=require('bcrypt')
const validator=require('email-validator')
const jwt=require('jsonwebtoken')
const registercontroller=async (req,res)=>{
   try {
    console.log(req.body)
    const {email,name,password}=req.body;
    if(!validator.validate(email)) return helper(res,"Email is invalid",404,false)
    const check=await usermodel.findOne({email:email})
    if(check){
        return helper(res,"User already exist",409,false);
    }
    const {_id} =await usermodel.create({email,name,password});
    await detailsmodel.create({userid:_id});
    return helper(res,"Successfully created",200,true);
   } catch (error) {
    return helper(res,error.message,500,false)
   }
}


const logincontroller=async (req,res)=>{
    try {
        console.log(req.body)
        const {email,password}=req.body
        if(!validator.validate(email)) return helper(res,"Email/Password is invalid",404,false)
        const user=await usermodel.findOne({email:email})
        if(!user){
            return helper(res,"User not exist",404,false)
        }
        const result=await bcrypt.compare(password,user.password)
        if(!result) return helper(res,"Email/Password is invalid",404,false)
        const {_id}=user;
        const token=jwt.sign({userid:_id,isuser:true},process.env.JWT_KEY,{expiresIn:'15d'});
        return res.status(200).json({
            message:token,
            flag:true
        })
    } catch (error) {
        return helper(req,error.message,500,false)
    }
}

const userdetailscontroller=async (req,res)=>{
    try {
        const {userid}=req.body;
        const result=await detailsmodel.findOne({userid});
        if(!result) return helper(res,"User not exist",404,false);
        else{
            return res.status(200).json({
                message:result,
                flag:true
            })
        }
    } catch (error) {
        return helper(res,error.message,404,false);
    }
}
module.exports={registercontroller,logincontroller,userdetailscontroller}