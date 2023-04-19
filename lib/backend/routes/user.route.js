const express=require('express')
const {registercontroller, logincontroller}=require('../controller/user.controller')
const router=express.Router()

router
.route('/register')
.post(registercontroller)

router
.route('/login')
.post(logincontroller)
module.exports=router
