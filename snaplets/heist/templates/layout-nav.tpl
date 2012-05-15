<div class="navbar navbar-fixed-top">
  <div class="navbar-inner">
    <div class="container">

      <a class="brand" href="/">Happy Snap</a>

      <ul class="nav pull-right">
          <ifLoggedOut>
          <li><a href="/signin">Sign in</a></li>
          <li><a href="/signup">Sign up</a></li>
          </ifLoggedOut> 

          <ifLoggedIn>
          <li><a href="/setting"><loggedInUser/></a></li>
          <li><a href="/signout">Sign out</a></li>
          </ifLoggedIn>

          <li><a href="/abount">About</a></li>

      </ul>
    </div>
  </div>
</div>

