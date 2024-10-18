<script setup lang="ts">
import { withoutTrailingSlash, joinURL } from 'ufo'
import type { BlogPost } from '~/types'

const route = useRoute()

const { data: post } = await useAsyncData(route.path, () => queryContent<BlogPost>(route.path).findOne())
if (!post.value) {
  throw createError({ statusCode: 404, statusMessage: 'Post not found', fatal: true })
}

const { data: surround } = await useAsyncData(`${route.path}-surround`, () => queryContent('/blog')
  .where({ _extension: 'md' })
  .without(['body', 'excerpt'])
  .sort({ date: -1 })
  .findSurround(withoutTrailingSlash(route.path))
, { default: () => [] })

const title = post.value.head?.title || post.value.title
const description = post.value.head?.description || post.value.description

useSeoMeta({
  title,
  ogTitle: title,
  description,
  ogDescription: description
})

if (post.value.image?.src) {
  const site = useSiteConfig()

  useSeoMeta({
    ogImage: joinURL(site.url, post.value.image.src),
    twitterImage: joinURL(site.url, post.value.image.src)
  })
} else {
  defineOgImage({
    component: 'Saas',
    // @ts-expect-error Object literal may only specify known properties, and 'title' does not exist in type 'OgImageOptions<"NuxtSeo"> | OgImagePrebuilt'.
    title,
    description,
    headline: 'Blog'
  })
}

const meta1 = document.createElement('meta')
meta1.setAttribute('property', 'og:url')
meta1.content = 'https://kirkepostille.vercel.app'

const meta2 = document.createElement('meta')
meta2.setAttribute('property', 'og:type')
meta2.content = 'article'

const meta3 = document.createElement('meta')
meta3.setAttribute('property', 'og:title')
meta3.content = 'Title testing'

const meta4 = document.createElement('meta')
meta4.setAttribute('property', 'og:description')
meta4.content = 'Testing description for social media'

const meta5 = document.createElement('meta')
meta5.setAttribute('property', 'og:image')
meta5.content = '/social-card.png'

const viewport = document.querySelector('meta[name="viewport"]')
viewport.after(meta5)
viewport.after(meta4)
viewport.after(meta3)
viewport.after(meta2)
viewport.after(meta1)
</script>

<template>
  <UContainer v-if="post">
    <UPageHeader
      :title="post.title"
      :description="post.description"
    >
      <template #headline>
        <UBadge
          v-bind="post.badge"
          variant="subtle"
        />
        <span class="text-gray-500 dark:text-gray-400">&middot;</span>
        <time class="text-gray-500 dark:text-gray-400">{{ new Date(post.date).toLocaleDateString('en', { year: 'numeric', month: 'short', day: 'numeric' }) }}</time>
      </template>

      <div class="flex flex-wrap items-center gap-3 mt-4">
        <UButton
          v-for="(author, index) in post.authors"
          :key="index"
          :to="author.to"
          color="white"
          target="_blank"
          size="sm"
        >
          <UAvatar
            v-bind="author.avatar"
            :alt="author.name"
            size="2xs"
          />

          {{ author.name }}
        </UButton>
      </div>
    </UPageHeader>

    <UPage>
      <UPageBody prose>
        <ContentRenderer
          v-if="post && post.body"
          :value="post"
        />

        <hr v-if="surround?.length">

        <UContentSurround :surround="surround" />
      </UPageBody>

      <template #right>
        <UContentToc
          v-if="post.body && post.body.toc"
          :links="post.body.toc.links"
        />
      </template>
    </UPage>
  </UContainer>
</template>
