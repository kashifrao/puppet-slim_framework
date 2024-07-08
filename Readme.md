# Slim

Slim is a PHP micro framework that helps you quickly write simple yet powerful web applications and APIs.

Slim 3.0^ requires php5.6+ with PSR4-autoloader


#  Slim Framework Directory Structure

+ cache/&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(installed by slim)
+ vendor/&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(installed by slim)
+ app
  - Controllers/
  - Models/
  - Views/
  - Middleware
  - routes.php
+ public/
  - aasets/
    - css/
    - js/
    - images/
    - favicon/
    - media/
    - data/
  - error_pages/
  - index.php
  - .htaccess
+ bootstrap/
  - app.php







#  Database Configuration
Define your database configuration paramaters in bootstrap/app.php file

```
#for database config
$config['db']['host']   = "localhost";
$config['db']['user']   = "xxxxxxxxx";
$config['db']['pass']   = "xxxxxxxxx";
$config['db']['dbname'] = "xxxxxxxxx";

# db container
    $container['db'] = function ($c) {
        $db = $c['settings']['db'];
        $pdo = new PDO("mysql:host=" . $db['host'] . ";dbname=" . $db['dbname'],
        $db['user'], $db['pass']);
        $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        $pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
        return $pdo;
};

```

#  Basic functions

#### Every Controller and Middleware should have a separate container
You can define it in bootstrap/app.php file
```
# homeController container
$container['HomeController'] = function ($container) {
   return new \App\Controllers\HomeController($container);
};
 
# homeMiddleware container
$container['HomeMiddleware'] = function ($container) {
   return new \App\Middleware\HomeMiddleware($container);
};

```

#### Every Controller and Middleware should have a separate namespace definition

_In Controller:_

namespace App\Controllers;    (define namespace on the first line, it will include all controllers .php file)

use App\Models\tableEntity;   (to include a model class, include each class separately)


_In Middleware:_

namespace App\Middleware;

use App\Controllers\hostController; 



#### Every Template file should include 

<? require ("template_header.phtml"); ?>     &nbsp;&nbsp;&nbsp;&nbsp;(first line of  the file).

to add sys functions, add all css assets





#  Examples 

##### simple get route
$app->get('/logout', 'HomeController:logout'); 

##### simple post route
app->post('/pinfo', 'HomeController:pinfo')->add('HomeMiddleware:checkMode')->add('HomeMiddleware:checkLogin')->add('HomeMiddleware:test');

##### index route passing through multiple middleware
$app->get('/', 'HomeController:index')->add('HomeMiddleware:checkMode')->add('HomeMiddleware:checkLogin')->add('HomeMiddleware:test1');

##### get route with input variable 
$app->get('/logs/{hname}',  'HomeController:logs')->add('HomeMiddleware:checkMode')->add('HomeMiddleware:checkLogin')->add('HomeMiddleware:test');


#  Template Views 

### messages.phtml
Use for custome messaging like alerts....

In your home controller render your view to messages page with parameters

$response = $this->container->view->render($response, "messages.phtml", [ "title" => "Login Fail ...", "msg_type" => "failure" , "msg_body" => "Invalid username or password."]);
            return $response;

  msg_type => 'failure/success/info'

### coming_soon.phtml
For Up coming pages, display coming soon message

response = $this->container->view->render($response, "coming_soon.phtml");


### maintenance.phtml
Used for putting your web application on maintenance mode

In bootstrap/app.php change this paramter to maintenance

$config['mode'] = 'production';

Middleware function checkMode will render this view to maintenance.phtml

### test.phtml

use for debugging purposes.

#  Using Javascript Alert booxes 


 // Alert boxes
 
```
        var var_error='<link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons"><center><i class="material-icons" style="font-size:70px;color:red;">error</i><b><center><font size=4 color=#2e86c1>';
        var var_success='<link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons"><center><i class="material-icons" style="font-size:70px;color:green;">done</i><b><center><font size=4 color=#2e86c1>';
        var var_info='<link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons"><center><i class="material-icons" style="font-size:70px;color:blue;">info</i><b><center><font size=4 color=#2e86c1>';
        # error/success/info boxes
        bootbox.alert({
        message: var_info+'message .....</font></b>',
        title: '<b><font size=4 color=#b03a2e>Alert !....</font></b>',
        closeButton: false,
        });
    document.getElementById('field_name').focus()
    return false
    }
``` 

// Confirm boxes

```
        var var_confirm='<link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons"><center><i class="material-icons" style="font-size:70px;color:red;">help</i><b><center><font size=4 color=#2e86c1>';
        bootbox.confirm({
            message: var_confirm+"<b><font size=4 color=#b03a2e>Are you sure you want to do this ??<br><br></font>",
            title: '<b><font size=4 color=#b03a2e>Alert !....</font></b>',
            closeButton: false,
                buttons: {
                    cancel: {
                        label: '<i class="fa fa-times"></i> Cancel'
                    },
                    confirm: {
                        label: '<i class="fa fa-check"></i> Confirm'
                    }
                },
        
            callback: function (result) {

                if (result) {  
                    
                    do this .....

                } else {

                    do this ...... 
                }
            }
        });
```


# Usefull functions

### Parse Input Variables

$sysClass->valid_data($str);     parse input string 
 

### Using Captcha Code 

$sysClass->captcha_div();     put this piece of code in that form where you want to display captcha code

// put this piece of code in that post function controller where you want to check captcha code

$cap_chk=$sys->captcha_check( $sys->valid_data($request->getParsedBody()['captcha'])  );

    if ($cap_chk=='error') {
    
        $response = $this->container->view->render($response, "messages.phtml", [ "title" => "Captcha Code Error ...", "msg_type" => "failure" , "msg_body" => "Captcha code deos not match or invalid."]);
        
        return $response;
        
    }

  


### Using Session Nonce

$sysClass->save_nonce();      put this piece of code in that form where you want to display captcha code

$sysClass->check_nonce();     put this piece of code in that post function controller where you want to check captcha code

### Encrypt / Decrypt variable

$sysClass->encrypt($str);     to encrypt variable

$sysClass->decrypt($str);     to decrypt variable




# Library function classes

Two usefull classes exisit in Controller folder, just instantiate the class and use the function

+ sysClass &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(system functions)
+ libClass &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(user generated functions)



# Using Ajax in post function

```
                    $.ajax({
                    method: "POST",
                    url: "/postfunction",    # must be defined in the route file
                    data: { field_name: val},
                   
                    })
                    .done(function( msg ) {
                        console.log(msg); 
                    });
```

