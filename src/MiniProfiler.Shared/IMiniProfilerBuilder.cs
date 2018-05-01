#if NET451
using System.Web.Services.Description;
#endif

namespace Microsoft.Extensions.DependencyInjection
{
    /// <summary>
    /// An interface for configuring MiniProfiler services.
    /// </summary>
    public interface IMiniProfilerBuilder
    {
        /// <summary>
        /// Gets the <see cref="IServiceCollection"/> where MiniProfiler services are configured.
        /// </summary>

#if !NET451
        // Microsoft.Extensions.DependencyInjection
        IServiceCollection Services { get; }
#else
        ServiceCollection Services { get; }
#endif

    }
}
