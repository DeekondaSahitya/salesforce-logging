# Logging

Salesforce Logging Framework

- Provides full stack dumping and limits report
- Controlled via custom setting
- Includes custom debug, exception debugging out to custom object  


# ChangeLog

# Usage

Logging hooks are implemented like this within each class

# Logger Setup - required methods

```
public class myClass(){

    public void myMethod(){
      Logger.push('myMethod','myClass');
        // Somecode
      Logger.pop();
    }

}
```
Each class/method must include: Logger.push and Logger.pop in order to caputre logs for the entire class stack

# Logging Custom Exception - capturing exceptions

```
public class myClass(){

    public void myMethod(){
      Logger.push('myMethod','myClass');

        try{
            // Somecode
        catch (Exception e){
            Logger.debugException (e);
        }
        
      Logger.pop();
    }

}
```



# Issues

# Todo's
- Add support for RecordTypes
