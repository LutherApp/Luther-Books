<script setup lang="ts">
import type { BlogPost } from '~/types'

const { data: page } = await useAsyncData('blog', () => queryContent('/blog').findOne())
if (!page.value) {
  throw createError({ statusCode: 404, statusMessage: 'Page not found', fatal: true })
}

const { data: posts } = await useAsyncData('posts', () => queryContent<BlogPost>('/blog')
  .where({ _extension: 'md' })
  .sort({ date: -1 })
  .find())

useSeoMeta({
  title: page.value.title,
  ogTitle: page.value.title,
  description: page.value.description,
  ogDescription: page.value.description
})

defineOgImage({
  component: 'Saas',
  // @ts-expect-error Object literal may only specify known properties, and 'title' does not exist in type 'OgImageOptions<"NuxtSeo"> | OgImagePrebuilt'.
  title: page.value.title,
  description: page.value.description
})

/*
        <!--
          @vue-expect-error The variable authors throws four errors;
          3 x Type 'bla bla bla' is not assignable to type 'bla bla bla'.
          1 x Property 'avatar' is optional in type 'bla bla bla' but required in type 'bla bla bla'.
         -->
*/
</script>

<template>
  <UContainer>
    <UPageHeader
      v-bind="page"
      class="py-[50px]"
    />

    <UPageBody>
      <UBlogList>
        <UBlogPost
          v-for="(post, index) in posts"
          :key="index"
          :to="post._path"
          :title="post.title"
          :description="post.description"
          :image="post.image"
          :date="new Date(post.date).toLocaleDateString('en', { year: 'numeric', month: 'short', day: 'numeric' })"
          :authors="post.authors"
          :badge="post.badge"
          :orientation="index === 0 ? 'horizontal' : 'vertical'"
          :class="[index === 0 && 'col-span-full']"
          :ui="{
            description: 'line-clamp-2'
          }"
        />
      </UBlogList>
    </UPageBody>
  </UContainer>
</template>
