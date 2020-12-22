using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using Microsoft.Owin;
using Owin;
using Planner.Models;

[assembly: OwinStartupAttribute(typeof(Planner.Startup))]
namespace Planner
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
            CreateAdminAndUserRoles();
        }

        private void CreateAdminAndUserRoles()
        {
            var context = new ApplicationDbContext();

            var roleManager = new RoleManager<IdentityRole>(new RoleStore<IdentityRole>(context));
            var userManager = new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(context));

            // Admin -> poate edita, adauga, sterge din baza de date
            if (!roleManager.RoleExists("Admin"))
            {
                var newRole = new IdentityRole();
                newRole.Name = "Admin";
                roleManager.Create(newRole);

                var newUser = new ApplicationUser();
                newUser.UserName = "admin@test.com";
                newUser.Email = "admin@test.com";

                var result = userManager.Create(newUser, "Pa55word!");
                if (result.Succeeded)
                {
                    userManager.AddToRole(newUser.Id, "Admin");
                }
            }

            // Child -> poate edita(sa modifice statusul)
            if (!roleManager.RoleExists("Child"))
            {
                var newRole = new IdentityRole();
                newRole.Name = "Child";
                roleManager.Create(newRole);

                var newUser = new ApplicationUser();
                newUser.UserName = "child@child.com";
                newUser.Email = "child@child.com";

                var result = userManager.Create(newUser, "Child");
                if (result.Succeeded)
                {
                    userManager.AddToRole(newUser.Id, "Child");
                }
            }

            
        }
    }
}
