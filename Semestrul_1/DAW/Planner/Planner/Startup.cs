using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(Planner.Startup))]
namespace Planner
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}
