const {usermodel}=require('../model/user.model')
const {detailsmodel}=require('../model/userdetail.model')
const {transactionmodel}=require('../model/transactions.model')
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
    await detailsmodel.create({userid:_id,name:name});
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

const addtransaction=async(req,res)=>{
    try {
    var {transactiontype,description,addamount,category,date,userid}=req.body;
        addamount=parseFloat(addamount)
        const result=await transactionmodel.create({transactiontype,description,amount:addamount,category,date,userid});
        if(result){
            var {amount,expense,income}=await detailsmodel.findOne({userid});
            if(transactiontype=="Expense"){
               amount=amount-addamount
               expense=expense+addamount
                await detailsmodel.findOneAndUpdate({userid},{amount,expense});
            }
            else{
                amount=amount+addamount
               income=income+addamount
               await detailsmodel.findOneAndUpdate({userid},{amount,income});
            }
            
            return helper(res,"Successfully added",200,true);
        }
    } catch (error) {
        return helper(res,error.message,400,false);
    }
}

const getpiechart= async (req,res)=>{
    try {
        var {userid}=req.body;
        const result=await transactionmodel.find({userid});
        if(!result) return helper(res,error.message,400,false);
        var map_used=new Map(
            [
                ["Food",0],
                ["Shopping",0],
                ["Medicines",0],
                ["Transport",0],
                ["Utilities",0],
                ["Education",0],
                ["Entertainment",0],
                ["Clothing",0],
                ["Rent",0],
                ["Others",0]
            ]
        );
        var array_length=result.length;
        for(let i=0;i<array_length;i++){
            const temperory=result[i];
            if(map_used.has(temperory.category)){
               var amount=map_used.get(temperory.category)
               map_used.set(temperory.category,amount+result[i].amount);
            }
            else{
                var amount=map_used.get("Others")
               map_used.set("Others",amount+result[i].amount);
            }
        }
        let resobject=[]
        map_used.forEach (function(value, key) {
            let temp={key,value}
            resobject.push(temp);
        })
        console.log(resobject)
        res.json({message:resobject})
    } catch (error) {
        return helper(res,error.message,400,false);
    }
}
module.exports={registercontroller,logincontroller,userdetailscontroller,addtransaction,getpiechart}