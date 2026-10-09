import { withMermaid } from 'vitepress-plugin-mermaid'
import apiSidebar from '../api/_sidebar.json'

// one sidebar for every page but the API, in reading order: the "previous" and "next" links at the bottom of a page
// follow it, so the documentation reads from the first page to the last
const docs = [
  {
    text: 'Start here',
    items: [
      { text: 'Introduction', link: '/guide/' },
      { text: 'Installation', link: '/guide/install' },
    ],
  },
  {
    text: 'Tutorial',
    items: [
      { text: 'Overview',                   link: '/manual/' },
      { text: '1. First vectors',           link: '/manual/tutorial/01-first-vectors' },
      { text: '2. Arithmetic',              link: '/manual/tutorial/02-arithmetic' },
      { text: '3. Lengths and angles',      link: '/manual/tutorial/03-lengths-angles' },
      { text: '4. Faces, area, volume',     link: '/manual/tutorial/04-faces' },
      { text: '5. A point and the body',    link: '/manual/tutorial/05-point' },
      { text: '6. Components: a slip wall', link: '/manual/tutorial/06-components' },
      { text: '7. Rotations and mirrors',   link: '/manual/tutorial/07-transforms' },
      { text: '8. Many vectors at once',    link: '/manual/tutorial/08-arrays' },
      { text: '9. Precision',               link: '/manual/tutorial/09-precision' },
      { text: '10. Printing and files',     link: '/manual/tutorial/10-io' },
      { text: '11. On the GPU',             link: '/manual/tutorial/11-gpu' },
    ],
  },
  {
    text: 'Recipes',
    items: [
      { text: 'Cookbook', link: '/manual/cookbook' },
    ],
  },
  {
    text: 'Reference',
    items: [
      { text: 'Feature map',               link: '/guide/features' },
      { text: 'The vector type',           link: '/guide/vector' },
      { text: 'Operators',                 link: '/guide/operators' },
      { text: 'Geometry',                  link: '/guide/geometry' },
      { text: 'Rotations and mirrors',     link: '/guide/transforms' },
      { text: 'Input and output',          link: '/guide/io' },
      { text: 'Precision and kinds',       link: '/guide/precision' },
      { text: 'Device-callable API',       link: '/guide/gpu' },
      { text: 'Behaviour and limitations', link: '/guide/limitations' },
    ],
  },
  {
    text: 'Project',
    items: [
      { text: 'Changelog',         link: '/guide/changelog' },
      { text: 'Contributing',      link: '/guide/contributing' },
      { text: 'Coverage analysis', link: '/guide/coverage-analysis' },
    ],
  },
]

export default withMermaid({
  title: 'VecFor',
  description: 'Vector algebra class for Fortran',
  base: '/VecFor/',
  head: [['link', { rel: 'icon', type: 'image/svg+xml', href: '/VecFor/logo.svg' }]],

  markdown: {
    math: true,
    languages: ['fortran-free-form', 'fortran-fixed-form'],
    languageAlias: {
      fortran: 'fortran-free-form',
      f90: 'fortran-free-form',
      f95: 'fortran-free-form',
      f03: 'fortran-free-form',
      f08: 'fortran-free-form',
      f77: 'fortran-fixed-form',
    },
  },

  themeConfig: {
    logo: '/logo.svg',
    nav: [
      { text: 'Home', link: '/' },
      { text: 'Start here', link: '/guide/', activeMatch: '^/guide/(index|install)' },
      { text: 'Tutorial', link: '/manual/tutorial/01-first-vectors', activeMatch: '^/manual/(index|tutorial/)' },
      { text: 'Cookbook', link: '/manual/cookbook', activeMatch: '^/manual/cookbook' },
      {
        text: 'Reference',
        link: '/guide/features',
        activeMatch: '^/guide/(features|vector|operators|geometry|transforms|io|precision|gpu|limitations)',
      },
      { text: 'API', link: '/api/' },
      {
        text: 'Project',
        items: [
          { text: 'Changelog',         link: '/guide/changelog' },
          { text: 'Contributing',      link: '/guide/contributing' },
          { text: 'Coverage analysis', link: '/guide/coverage-analysis' },
        ],
      },
    ],

    sidebar: {
      '/guide/': docs,
      '/manual/': docs,
      '/api/': [
        {
          text: 'API Reference',
          items: [
            { text: 'Overview', link: '/api/' },
          ],
        },
        ...apiSidebar,
      ],
    },

    socialLinks: [
      { icon: 'github', link: 'https://github.com/szaghi/VecFor' },
    ],

    search: {
      provider: 'local',
    },

    footer: {
      message: 'Released under the GPL v3, BSD 2-Clause, BSD 3-Clause or MIT License.',
      copyright: 'Copyright © 2015-2026 Stefano Zaghi',
    },
  },

  mermaid: {},

  vite: {
    // Build with an explicit modern JS target so the docs compile regardless of
    // which mermaid/vitepress/esbuild versions npm resolves. Vite's default
    // es2020 target forces esbuild to down-level modern syntax (e.g. the
    // destructuring mermaid 11.16+ emits), which it refuses to do and the build
    // dies. es2022 needs no lowering and is within VitePress's browser floor.
    build: {
      target: 'es2022',
    },
    optimizeDeps: {
      include: ['mermaid'],
    },
  },
})
