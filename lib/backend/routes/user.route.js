const express=require('express')
const {registercontroller, logincontroller,userdetailscontroller}=require('../controller/user.controller')
const { verifier } = require('../middlewares/jwtverify')
const router=express.Router()

router
.route('/register')
.post(registercontroller)

router
.route('/login')
.post(logincontroller)


router
.route('/details')
.post(verifier,userdetailscontroller)





module.exports=router