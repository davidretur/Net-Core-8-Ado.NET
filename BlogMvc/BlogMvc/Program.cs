using BlogMvc;
using Microsoft.AspNetCore.Authentication.Cookies;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllersWithViews();
// agregamos servicio de conexion de tipo Singleton esta clase se usa para interactuar con la base de datos
// esta instancia sera global para toda la aplicacion
builder.Services.AddSingleton(new Contexto(builder.Configuration.GetConnectionString("conexion")));
// agregamos un servivio para la autenticacion utilizando cookies con el esquema de aut y se establece la ruta de inicio sesion
builder.Services.AddAuthentication(CookieAuthenticationDefaults.AuthenticationScheme).AddCookie(option =>
{
    option.LoginPath = "/Cuenta/login";
});
var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
}
app.UseStaticFiles();

app.UseRouting();
// implemntamos la autenticacion
app.UseAuthentication();

app.UseAuthorization();
// cofiguramos redireccion global

app.UseStatusCodePagesWithRedirects("~/Home/Index");
app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();
