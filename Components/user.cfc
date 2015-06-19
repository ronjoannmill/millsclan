<cfcomponent>
	<cffunction name="init" access="public" returntype="user">
		<!--- do nothing Pseudo constructor --->
		
		<cfreturn this>
	</cffunction>


	<!--- IRD-226  9/22/2014 --->
	<cffunction name="loginUser" access="public" returntype="struct">
		<cfargument name="userName" type="string" required="true">
		<cfargument name="password" type="string" required="false">
		<cfargument name="refreshMyProfile" type="boolean" required="false" default="false" 
					hint="used from my settings page, to repopulate the users session after the changes he made 
					to his profile.">
		<cfargument name="isProxyLogin" type="boolean" required="false" default="false" 
					hint="same as refresh my login. except that it required an additional argument called 
					originalUserName. This is used for super admin to login as a different user.">
		<cfargument name="originalUserID" type="numeric" required="false" hint="required when pseudoLogin is true">
		<cfargument name="emailAddress" type="string" required="false" 
        			hint="if user name and email address match the existings on file, reset the current password and a temporary passsword is sent to the email address.">

		<cfset var checkUserPassword = true>
        <cfset var sendTemporaryPassword = false>
		<cfset var contractObj = createObject("component", "#request.componentRoot#.contract").init()>
		<cfset var entityObj = createObject("component", "#request.componentRoot#.entity").init()>
		<cfset var noteObj = createObject("component", "#request.componentRoot#.notification").init()>        
		<cfset var qAssignedContractPrivileges = "">
		<cfset var i =0> <cfset var j = 0>
		<cfset var userAccount = "">
		<cfset var retStruct = "">
		<cfset var entityDetails = "">
		<cfset var proxyUserDetails = "">
		<cfset var qOwnContracts = "">
		<cfset var qAgencyContracts = "">        
		
		<cfif arguments.refreshMyProfile or arguments.isProxyLogin>
			<cfset checkUserPassword = false>
		</cfif>
        
		<cfif arguments.isProxyLogin and not structKeyExists(arguments, "originalUserID")>
			<cfthrow type="PTMS.INSUFFICIENT_ARGUMENTS" detail="user.loginUser:When pseudoLogin is desired, need to pass 
						the original user name also to the function.">
		</cfif>
		
		<cfset userAccount = this.getUserAccount(userName=arguments.userName)>
        
		<cfif userAccount.recordCount lte 0>
			<cfthrow type="PTMS.NO_USER_EXISTS" detail="there is no user with this username">
		</cfif>
        
        <cfif structKeyExists(arguments, "emailAddress") AND (len(arguments.password) eq 0) AND (compareNoCase(arguments.emailAddress, "YourEmailAddress") neq 0)>
        	<cfset sendTemporaryPassword = true>
        </cfif>         
        
		<cfif checkUserPassword AND (NOT sendTemporaryPassword) AND (compare(this.decryptPassword(passwordString=userAccount.password), arguments.password) neq 0)>
			<cfthrow type="PTMS.INVALID_PASSWORD" detail="username and password do not match">
		</cfif>
        
        <cfif sendTemporaryPassword AND (compareNoCase(arguments.emailAddress, userAccount.email_address) neq 0)>
			<cfthrow type="PTMS.INVALID_EMAILADDRESS" detail="Your email address is invalid or is not in the system">        
        </cfif>         

        <cfif sendTemporaryPassword AND (compareNoCase(arguments.emailAddress, userAccount.email_address) eq 0)>

			<cfset newTemporaryPassword = this.generateRandomPassword() >
	        <cfset encryptedNewTemporaryPassword = trim(encrypt(newTemporaryPassword, request.passwordSeed, request.algorithm, request.encoding))>

			<cfquery datasource="#request.dsn#" name="updateUserTemporaryPassword">
				UPDATE user
				SET force_password_change = 1, password = "#encryptedNewTemporaryPassword#" 
				WHERE user_name = "#arguments.userName#"
			</cfquery>
        
			<cfscript>
				emailContent = structNew();
				emailContent.mailContent = "Your password for Quicknom has been changed. The following is your temporary password,<br/><br/>#newTemporaryPassword#<br/>";
				noteObj.sendMail(toAddress="#arguments.emailAddress#", subject="Quicknom Temporary Password", templateName="generic_email.txt", emailType="html", variableStruct=emailContent);
			</cfscript>                    
        
			<cfthrow type="PTMS.TEMPORARY_PASSWORD_SENT" detail="A temporary password has been sent to user's email">        
        </cfif>         
		
		<cfif userAccount.is_active lte 0 and checkUserPassword>
			<cfthrow type="PTMS.INACTIVE_USER" detail="This account has been deactivated, please contact the administrator.">
		</cfif>
		<!--- build the privilege struct --->
		<cfif userAccount.role_id lte 0>
			<cfthrow	type="PTMS.NO_ROLE" 
						detail="There is no role associated with this account. Contact administrator.">
		</cfif>
		
		<cfset roleObj = createObject("component", "#request.componentRoot#.role")>
		<cfset retStruct = roleObj.getRoleStruct(roleID=userAccount.role_id)>
		<cfif not retStruct.isActiveRole>
			<cfthrow	type="PTMS.INACTIVE_ROLE" 
						detail="This account has been assigned an inactive role.">
		</cfif>
		
		<!--- Own Contracts if any --->
		<cfset qOwnContracts = contractObj.getContract(entityID=userAccount.entity_id)>
		<cfset retStruct.ownContracts = valueList(qOwnContracts.ID)>
		
		<!--- Agency Contracts if any  --->
		<cfset qAgencyContracts = contractObj.getAgencyContracts(entityID=userAccount.entity_id)>
		<cfset retStruct.agencyContracts = valueList(qAgencyContracts.ID)>
		
		<!--- Assigned Contract Specific Privileges --->
		<cfset qAssignedContractPrivileges = contractObj.getContractUserDetails(userID=userAccount.ID)>
		
		<cfset retStruct.assignedContracts = structNew()>
		<cfif qAssignedContractPrivileges.recordCount gt 0>
			<cfquery dbtype="query" name="qGetDistinctPrivs">
				SELECT 	DISTINCT ROLE_MASTER_ATTRIBUTE_ID, ATTRIBUTE_CODE
				FROM 	qAssignedContractPrivileges
			</cfquery>
			<cfloop from="1" to="#qGetDistinctPrivs.recordCount#" index="i">
				
				<cfquery dbtype="query" name="qGetDistinctContractIDs">
					SELECT 	DISTINCT CONTRACT_ID 
					FROM 	qAssignedContractPrivileges
					WHERE 	ROLE_MASTER_ATTRIBUTE_ID = #qGetDistinctPrivs.role_master_attribute_id[i]#
				</cfquery>
				<cfif qGetDistinctContractIDs.recordCount gt 0>
					<cfset retStruct.assignedContracts[qGetDistinctPrivs.attribute_code[i]] = valueList(qGetDistinctContractIDs.contract_id)>
				</cfif>
			</cfloop>
		</cfif>
		
		<cfset retStruct.resetPassword = false>
		<cfset retStruct.isLoggedIn = true>
		<cfset retStruct.firstName = userAccount.first_name>
		<cfset retStruct.lastName = userAccount.last_name>
		<cfset retStruct.email = userAccount.email_address>
		<cfset retStruct.userID = userAccount.ID>
		<cfset retStruct.entityID = userAccount.entity_id>
		<cfset entityDetails = entityObj.getEntity(entityID=userAccount.entity_id)>
		<cfset retStruct.isOperator = false>
		<cfset retStruct.isShipper = false>
		<cfset retStruct.isPointOperator = false>
		<cfset retStruct.isAgent = false>

		<cfif entityDetails.is_operator gt 0>
			<cfset retStruct.isOperator = true>
		</cfif>
		<cfif entityDetails.is_shipper gt 0>
			<cfset retStruct.isShipper = true>
		</cfif>
		<cfif entityDetails.is_point_operator gt 0>
			<cfset retStruct.isPointOperator = true>
		</cfif>
		<cfif entityDetails.is_agent gt 0>
			<cfset retStruct.isAgent = true>
		</cfif>
		<cfquery datasource="#request.dsn#" name="getAssignedPoints">
			SELECT 	A.LOCATION_ID 
			FROM 			ENTITY_LOCATION A 
					JOIN 	LOCATION B 					ON (A.LOCATION_ID = B.ID) 
					JOIN 	LOCATION_TYPE C				ON (B.LOCATION_TYPE_ID = C.ID) 
					JOIN 	LOCATION_ACTIVE_STATUS D	ON (B.ID = D.LOCATION_ID AND D.IS_ACTIVE = 1) 
			<!---WHERE 	A.ENTITY_ID = #userAccount.entity_id# AND C.LOCATION_TYPE_CODE = 'IC' AND---> <!---changed to include 'PP' 01/9/10 by RM for TASK 134--->
			WHERE 	A.ENTITY_ID = #userAccount.entity_id# AND C.LOCATION_TYPE_CODE IN ('IC','PP') AND 
					D.START_DATE <= #createODBCDate(now())# AND (D.END_DATE IS NULL OR D.END_DATE >= #createODBCDate(now())#)
		</cfquery>
		<cfset retStruct.assignedPoints = valueList(getAssignedPoints.location_ID)>
		<!--- this must be used for all the logging purposes, in case of pseudologin this will have actual user's ID --->
		<cfset retStruct.trackingUserID = userAccount.ID>
		<cfset retStruct.userName = userAccount.user_name>
		<cfset retStruct.roleID = userAccount.role_id>
		<cfset retStruct.lastLoginDate = userAccount.last_login_date>
		<cfset retStruct.dateLastPasswordChanged = userAccount.date_password_last_changed>
		
		<cfset retStruct.originalUserName = "">
		<cfset retStruct.orginalUserDisplayName = "">
		
		<cfset retStruct.isProxyLogin = false>
		<cfif arguments.isProxyLogin>
			<cfset retStruct.isProxyLogin = true>
			<cfset retStruct.trackingUserID = arguments.originalUserID>
			<cfset proxyUserDetails = this.getUserAccount(userID=arguments.originalUserID)>
			<cfset retStruct.originalUserName = proxyUserDetails.user_name>
			<cfset retStruct.orginalUserDisplayName = proxyUserDetails.first_name & " " & proxyUserDetails.last_name>
		</cfif>
		
		<cfset retStruct.daysLeftBeforePasswordExpires = 99>
		<cfif val(retStruct.noOfDaysBeforePasswordExpires) gt 0 and isDate(retStruct.dateLastPasswordChanged)>
			<cfset retStruct.daysLeftBeforePasswordExpires = val(retStruct.noOfDaysBeforePasswordExpires) - dateDiff("d", dateFormat(retStruct.dateLastPasswordChanged, "mm/dd/yyyy"), dateFormat(now(), "mm/dd/yyyy"))>
		</cfif>
        
		<cfif 	not arguments.isProxyLogin and not arguments.refreshMyProfile and 
				(userAccount.force_password_change gt 0  or 
				(retStruct.daysLeftBeforePasswordExpires lte 0 and retStruct.doesPasswordExpire) or 
				not isDate(retStruct.dateLastPasswordChanged))>
			<cfset retStruct.resetPassword = true>
			<cfset retStruct.isLoggedIn = false>
		</cfif>
        
		<cfif not arguments.isProxyLogin and not arguments.refreshMyProfile>
			<cfset this.updateLastLoginDate(userID=userAccount.ID)>
		</cfif> 
        
		<cfreturn retStruct>
	</cffunction><!--- end of loginUser() --->

	<!--- IRD-226  9/25/2014 --->
	<cffunction name="generateRandomPassword" access="public" returntype="string">
		<cfset strLowerCaseAlpha = "abcdefghjkmnpqrstuvwxy" />
		<cfset strUpperCaseAlpha = UCase(strLowerCaseAlpha) />
		<cfset strNumbers = "0123456789" />
		<cfset strOtherChars = "!$%&" />
		<cfset strAllValidChars = (strLowerCaseAlpha & strUpperCaseAlpha & strNumbers & strOtherChars) >
		<cfset arrPassword = ArrayNew( 1 ) />
		<cfset arrPassword[1] = Mid(strNumbers, RandRange(1, Len(strNumbers)), 1) >
		<cfset arrPassword[2] = Mid(strLowerCaseAlpha, RandRange(1, Len(strLowerCaseAlpha)), 1) >
		<cfset arrPassword[3] = Mid(strUpperCaseAlpha, RandRange(1, Len( strUpperCaseAlpha)), 1) >
		<cfloop index="intChar" from="#(ArrayLen(arrPassword) + 1)#" to="8" step="1"> 
			<cfset arrPassword[intChar] = Mid(strAllValidChars, RandRange(1, Len(strAllValidChars)), 1) > 
		</cfloop>
		<cfset CreateObject( "java", "java.util.Collections" ).Shuffle(arrPassword) >
		<cfset strPassword = ArrayToList(arrPassword, "") >        
		<cfreturn strPassword />
	</cffunction>
	
	
	<cffunction name="validateUsersPassword" access="public" returntype="boolean" hint="this is used to find if the user's password is ok from password change form">
		<cfargument name="password" type="string" required="true">
		<cfargument name="userID" type="numeric" required="true">
		<cfquery datasource="#request.dsn#" name="getUsersPassword">
			SELECT 	PASSWORD 
			FROM 	USER
			WHERE 	ID = #arguments.userID#
		</cfquery>
		<cfif compare(this.decryptPassword(getUsersPassword.password), arguments.password) eq 0>
			<cfreturn true>
		</cfif>
		<cfreturn false>
	</cffunction>
	
	<cffunction name="updateLastLoginDate" access="package" returntype="boolean">
		<cfargument name="userID" type="numeric" required="true">
		<cfquery datasource="#request.dsn#" name="updateLoginDate">
			UPDATE USER
			SET 
				LAST_LOGIN_DATE = NOW()
			WHERE ID = #arguments.userID#
		</cfquery>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="updateUserPassword" access="public" returntype="boolean">
		<cfargument name="userID" type="numeric" required="true">
		<cfargument name="password" type="string" required="true">
		<cfargument name="resetLoginDate" type="boolean" required="false" default="false">
		<cfset var encryptedString = replaceNoCase(this.encryptPassword(passwordString=arguments.password), "\", "\\", "all")>
		<cfquery datasource="#request.dsn#" name="updatePassword">
			UPDATE USER
			SET 
				PASSWORD = '#encryptedString#', 
				modifiedDate = NOW()
			WHERE ID = #arguments.userID#
		</cfquery>
		<cfreturn true>
	</cffunction>
	

	<cffunction name="isDuplicateUserName" access="public" returntype="boolean" hint="checks if the userName is already in use">
		<cfargument name="userName" type="string" required="true">
		<cfargument name="userID" type="numeric" required="false" default="0">
		<cfquery datasource="#request.dsn#" name="checkDuplicateUserName">
			SELECT 	USER_NAME 
			FROM 	USER
			WHERE 	USER_NAME = '#arguments.userName#'
					<cfif arguments.userID gt 0>
						AND ID != #arguments.userID#
					</cfif>
		</cfquery>
		<cfif checkDuplicateUserName.recordCount gt 0>
			<cfreturn true>
		</cfif>
		<cfreturn false>
	</cffunction>
	
	<cffunction name="isValidUserName" access="public" returntype="boolean" hint="checks if the userName is in valid format">
		<cfargument name="userName" type="string" required="true">
		<cfargument name="userID" type="numeric" required="false" default="0">
		<cfset validateUserName = true>
		<cfif arguments.userID gt 0>
			<cfquery datasource="#request.dsn#" name="getExistingUserName">
				SELECT 	USER_NAME 
				FROM 	USER
				WHERE 	ID = #arguments.userID#
			</cfquery>
			<!--- checking to make sure that these validation only apply to new usernames --->
			<cfif compareNoCase(getExistingUserName.user_name, arguments.userName) eq 0>
				<cfset validateUserName = false>
			</cfif>
		</cfif>
		<cfif validateUserName>
			<cfif reFindNoCase("[^a-z_0-9]", arguments.userName) gt 0>
				<cfreturn false>
			</cfif>
			<cfif len(trim(arguments.userName)) lt 6>
				<cfreturn false>
			</cfif>
		</cfif>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="isValidPassword" access="public" returntype="boolean" hint="checks the format for password">
		<cfargument name="password" type="string" required="true">
		<cfif len(trim(arguments.password)) lt 8 or reFindNoCase("([a-z][0-9]){1,}", arguments.password) lte 0>
			<cfreturn false>
		</cfif>
		<cfreturn true>
	</cffunction>
	
	
	<cffunction name="validateResetPasswordForm" access="public" returntype="struct" hint="for blackberry a special screen is created for resetting user password">
		<cfset var retStruct = structNew()>
		<cfset var arrCtr = 1>
		<cfset var errors = structNew()>
		<cfset var errArr = arrayNew(1)>
		<cfif len(trim(form.password)) lt 8>
			<cfset structInsert(errors, "password", "required field")>
			<cfset errArr[arrCtr] = structNew()>
			<cfset structInsert(errArr[arrCtr], "password", "Passwords must be a minimum of eight alphanumeric characters.")>
			<cfset arrCtr = arrCtr + 1>
		<cfelseif compare(form.password, form.confirmPassword) neq 0>
			<cfset structInsert(errors, "password", "passwords don't match")>
			<cfset structInsert(errors, "confirmPassword", "passwords don't match")>
			<cfset errArr[arrCtr] = structNew()>
			<cfset structInsert(errArr[arrCtr], "password", "Passwords you entered don't match.")>
			<cfset arrCtr = arrCtr + 1>
		</cfif>
		<cfset retStruct.errors = errors>
		<cfset retStruct.errArr = errArr>
		<cfreturn retStruct>
	</cffunction>
	
	<cffunction name="resetPasswordFormDoPost" access="public" returntype="boolean">
		<cfargument name="userID" type="numeric" required="true">
		<cfargument name="password" type="string" required="true">
		<cfset var qUpdateUser = "">
		<cfset var encryptedPassword = replaceNoCase(this.encryptPassword(passwordString=arguments.password), "\", "\\", "all")>
		<cfquery datasource="#request.dsn#" name="qUpdateUser">
			UPDATE USER 
			SET 
				
				PASSWORD = '#encryptedPassword#',
				FORCE_PASSWORD_CHANGE = 1
			WHERE ID = #arguments.userID#
		</cfquery>
		<cfreturn true>
	</cffunction>
	
	
	<cffunction name="passwordChangeDoPost" access="public" returntype="struct">
		<cfscript>
			var argStruct = ""; 
			var validationStruct = this.validatePasswordChangeForm();
			if(not structIsEmpty(validationStruct.errors))
				return validationStruct;
		</cfscript>	
		<cfset argStruct = structNew()>
		<cfset argStruct.userID = request.userDataStruct.userID>
		<cfset argStruct.password = form.password>
		<cfset argStruct.resetLoginDate = true>
		<cfset this.updateUserPassword(argumentCollection=argStruct)>
		<cflock scope="session" type="exclusive" throwontimeout="yes" timeout="30">
			<cfset session.userDataStruct.isLoggedIn = true>
			<cfset session.userDataStruct.resetPassword = false>
		</cflock>
		<cfreturn validationStruct>
	</cffunction>
	
	<cffunction name="validatePasswordChangeForm" access="package" returntype="struct">
		<cfscript>
			var retStruct = structNew(); var arrCtr = 1; var errors = structNew(); var errArr = arrayNew(1);
		</cfscript>
		<cfif len(trim(form.oldPassword)) lte 0>
			<cfset structInsert(errors, "oldPassword", "required field")>
			<cfset errArr[arrCtr] = structNew()>
			<cfset structInsert(errArr[arrCtr], "oldPassword", "Old password is required.")>
			<cfset arrCtr = arrCtr + 1>
		<cfelseif not this.validateUsersPassword(password=form.oldPassword, userID=request.userDataStruct.userID)>
			<cfset structInsert(errors, "oldPassword", "incorrect password")>
			<cfset errArr[arrCtr] = structNew()>
			<cfset structInsert(errArr[arrCtr], "oldPassword", "The existing password entered is incorrect.")>
			<cfset arrCtr = arrCtr + 1>
		</cfif>
		
		
		<cfif len(trim(form.password)) lte 0>
			<cfset structInsert(errors, "password", "required field")>
			<cfset errArr[arrCtr] = structNew()>
			<cfset structInsert(errArr[arrCtr], "password", "New Password is a required field.")>
			<cfset arrCtr = arrCtr + 1>
		</cfif>
		
		<cfif len(trim(form.confirmPassword)) lte 0>
			<cfset structInsert(errors, "confirmPassword", "required field")>
			<cfset errArr[arrCtr] = structNew()>
			<cfset structInsert(errArr[arrCtr], "confirmPassword", "Confirm new password is a required field.")>
			<cfset arrCtr = arrCtr + 1>
		</cfif>
		
		
		<cfif len(trim(form.password)) gt 0 and len(trim(form.confirmPassword)) gt 0>
			<cfif compare(form.password, form.confirmPassword) neq 0>
				<cfset structInsert(errors, "password", "passwords don't match.")>
				<cfset structInsert(errors, "confirmPassword", "passwords don't match.")>
				<cfset errArr[arrCtr] = structNew()>
				<cfset structInsert(errArr[arrCtr], "password", "Password and confirm passwords don't match.")>
				<cfset arrCtr = arrCtr + 1>
			<cfelseif compareNoCase(form.oldPassword, form.password) eq 0>
				<cfset structInsert(errors, "password", "")>
				<cfset errArr[arrCtr] = structNew()>
				<cfset structInsert(errArr[arrCtr], "password", "New password must be different from the existing password")>
				<cfset arrCtr = arrCtr + 1>
			<cfelseif not this.isValidPassword(password=form.password)>
				<cfset structInsert(errors, "password", "")>
				<cfset errArr[arrCtr] = structNew()>
				<cfset structInsert(errArr[arrCtr], "password", "Password must be atleast 8 characters and should have both numeric and alphanumeric characters")>
				<cfset arrCtr = arrCtr + 1>
			</cfif>
		</cfif>
		<cfset retStruct.errors = errors>
		<cfset retStruct.errArr = errArr>
		<cfreturn retStruct>
	</cffunction>

	
	<cffunction name="encryptPassword" access="package" returntype="string">
		<cfargument name="passwordString" type="string" required="true">
		<cfif isDefined("passwordString") and passwordString neq "">
			<cfset retStr = trim(encrypt(passwordString, request.passwordSeed, request.algorithm, request.encoding))>
		<cfelse>
			<cfset retStr = "">
		</cfif>
		<cfreturn retStr>		
	</cffunction>
	
	<cffunction name="decryptPassword" access="package" returntype="string">
		<cfargument name="passwordString" type="string" required="true">
		<cfset retStr = trim(decrypt(passwordString, request.passwordSeed, request.algorithm, request.encoding))>
		<cfreturn retStr>		
	</cffunction>
</cfcomponent>