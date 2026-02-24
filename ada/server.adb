with AWS.Server;
with AWS.Response;
with AWS.Status;
with AWS.MIME;
with AWS.Messages;
with AWS.Config;
with AWS.Config.Set;

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
   C  : AWS.Config.Object;

begin
   AWS.Config.Set.Server_Host (C, "0.0.0.0");
   AWS.Config.Set.Server_Port (C, 8080);
   AWS.Config.Set.Reuse_Address (C, True);

   AWS.Server.Start
     (Web_Server => WS,
      Name       => "Hello Server",
      Callback   => Hello_CB'Unrestricted_Access,
      Config     => C);

   AWS.Server.Wait (AWS.Server.Forever);
end Server;
