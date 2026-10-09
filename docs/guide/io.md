---
title: Input and output
---

# Input and output

## printf

```fortran
call v%printf([unit=] [, prefix=] [, sep=] [, suffix=] [, iostat=] [, iomsg=])
```

| Argument | Type | Default | Meaning |
|---|---|---|---|
| `unit` | `integer(I4P)`, in | standard output | an open unit |
| `prefix` | `character(*)`, in | `''` | written before the components |
| `sep` | `character(*)`, in | `', '` | written between the components |
| `suffix` | `character(*)`, in | `''` | written after the components |
| `iostat` | `integer(I4P)`, out | | the I/O status |
| `iomsg` | `character(*)`, out | | the I/O message |

One line: `prefix`, x, `sep`, y, `sep`, z, `suffix`. Each component is written with a sign and the shortest digits that
read back as the same value (`+0.1`, `-2.0`, `+0.3333333333333333`, `+1.0E-7`), by PENF's `str`. For a fixed layout,
print the components with a format of your own.

## save_into_file and load_from_file

```fortran
call v%save_into_file(unit= [, fmt=] [, pos=] [, iostat=] [, iomsg=])
call v%load_from_file(unit= [, fmt=] [, pos=] [, iostat=] [, iomsg=])
```

| Argument | Type | Meaning |
|---|---|---|
| `unit` | `integer(I4P)`, in | an open unit, required |
| `fmt` | `character(*)`, in | a format for three reals, e.g. `'(3F10.4)'`, for a formatted unit |
| `pos` | `integer(I8P)`, in | the position, in file storage units, on a unit opened with `access='stream'` |
| `iostat` | `integer(I4P)`, out | the I/O status: 0, negative at the end of the file, positive on an error |
| `iomsg` | `character(*)`, out | the I/O message |

Each call writes or reads one record of three values, `x`, `y`, `z`, on a unit opened by you:

- **unformatted** (no `fmt`): the exact bits; a double precision vector takes 24 bytes.
- **formatted** (`fmt` given): text, with the digits of the format only. `fmt` is passed to the `write`/`read`
  statement as a character format: `'*'` is not list-directed I/O and is rejected; list-directed I/O is
  `read(u, *) v%x, v%y, v%z`.
- **stream** (`pos` given): at that position, on a unit opened with `access='stream'`; vector `n` of a file of vectors
  starts at `(n - 1) * v%iolen() + 1`.

There is no `rec=`: on a direct access unit, write and read the components (`write(u, rec=i) v%x, v%y, v%z`).

## iolen

`v%iolen()`, or `iolen(v)`, is the length of the three components in file storage units, as
`inquire(iolength=n) v%x, v%y, v%z`: the `recl` of a direct access file of vectors, the stride of a stream file. With
gfortran a storage unit is a byte: 12 for `vector_R4P`, 24 for `vector_R8P`.

## Errors

::: warning Always pass iostat
The three procedures **never stop the program** on an I/O error, unlike a plain `read` or `write`: without `iostat` a
failed read or write is silently ignored, and on a read the vector keeps the value it had. Pass `iostat`, and check it.
:::

```fortran
call v%load_from_file(unit=u, iostat=ios, iomsg=msg)
if (ios /= 0) error stop 'cannot read the vector: '//trim(msg)
```

`iolen` is not `pure`, and neither are the three procedures: they cannot be called from a `pure` procedure, nor are
they elemental.
