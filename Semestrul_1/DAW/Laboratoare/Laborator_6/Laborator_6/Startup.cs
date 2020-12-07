using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(Laborator_6.Startup))]
namespace Laborator_6
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}
