with AWS.Server;
with AWS.Response;
with AWS.Status;
with AWS.MIME;

procedure Server is

   function Hello_CB (Request : AWS.Status.Data) return AWS.Response.Data is
      URI : constant String := AWS.Status.URI (Request);
   begin
      if URI = "/hello" then
         return AWS.Response.Build
           (Content_Type => AWS.MIME.Application_JSON,
            Message_Body => "{""message"":""Hello, world!""}");
      else
         return AWS.Response.Build
           (Content_Type => AWS.MIME.Text_Plain,
            Message_Body => "Not found",
            Status_Code  => AWS.Messages.S404);
      end if;
   end Hello_CB;

   WS : AWS.Server.HTTP;

begin
   AWS.Server.Start (WS, "Hello Server", Hello_CB'Unrestricted_Access, Port => 8080);
   AWS.Server.Wait (AWS.Server.Forever);
end Server;
