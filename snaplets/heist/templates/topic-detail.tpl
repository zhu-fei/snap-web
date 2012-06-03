<apply template="layout">

<ifNotFound>
  <div class="alert alert-error"> 
    <ul>
      <li><exceptionValue/></li>
    </ul>
  </div>
  <returnToHome />
</ifNotFound>

<ifFound>

  <article>
    <h2>
      <topicTitle />
    </h2>
    <p><topicAuthor/></p>
    <p><topicContent/></p>
    <p><topicCreateAt/></p>
    <p><topicUpdateAt/></p>
  </article>

  <!-- FIXME: Show me when has authorization.-->
  <div name="topicToolbar">
      <a href="/topicput/${oid}">Edit</a>
  </div>
  


</ifFound>

  <bind tag="bottom-scripts">
    <apply template="js-markdown" />
  </bind>
  
</apply>

 <!-- FIXME: show me when user login
  
  <ifLoggedIn>  
    <a href="#">Share</a>
    <a href="/favorite">Save</a>
  </ifLoggedIn>
  
  -->
